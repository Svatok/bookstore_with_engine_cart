feature 'products/show:' do
  let(:user) { create :user }
  let(:order) { create :order }
  let(:order_items) { create_list :order_items, 2, order: order }
  let(:shippings) { create_list :product, 3, :shipping }
  
  before do
    sign_in create(:user)
    order.state = 'delivery'
    visit ('/checkouts')
    session['order_id'] = order.id
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit edit_user_registration_path
    expect(page).to have_current_path('/users/login')
  end
  
  context 'delivery check content' do
    scenario 'deliveries must be present' do
      expect(page).to have_selector('.radio-text', count: 3)
    end      
    scenario 'delivery checked' do
      find(:css, ".radio-input").first.set(true)
      expect { click_button 'Save and Continue' }.to change{order.total_price}
      expect(page).to have_content('Credit Card')
    end  
    scenario 'delivery not checked' do
      click_button 'Save and Continue'
      expect(page).to have_content("Choose delivery!")
    end    
  end
 
end