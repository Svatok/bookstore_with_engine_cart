feature 'products/show:' do
  let(:user) { create :user }
  let(:order) { create :order }
  let(:order_items) { create_list :order_items, 2, order: order }
  let(:payment) { create :payment, order: order }
  
  before do
    sign_in create(:user)
    order.state = 'payment'
    visit ('/checkouts')
    session['order_id'] = order.id
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit edit_user_registration_path
    expect(page).to have_current_path('/users/login')
  end
  
  context 'payment content' do
    scenario 'when payment filled go to next step' do
      fill_in 'payment_card_number', with: '1234123412341234'
      fill_in 'payment_name_on_card', with: 'Test User'
      fill_in 'payment_mm_yy', with: '12/22'
      fill_in 'payment_cvv', with: '122'
      click_button 'Save and Continue'
      expect(page).to have_content("edit")
    end      
    scenario 'when payment not filled show message' do
      click_button 'Save and Continue'
      expect(page).to have_content("Card number can't be blank")
      expect(page).to have_content("Name on card can't be blank")
      expect(page).to have_content("Mm yy can't be blank")
      expect(page).to have_content("Cvv can't be blank")
    end  
  end
 
end