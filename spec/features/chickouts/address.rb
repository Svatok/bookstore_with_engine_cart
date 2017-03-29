feature 'products/show:' do
  let(:user) { create :user }
  let(:order) { create :order }
  let(:order_items) { create_list :order_items, 2, order: order }
  let(:billing_address) { create :address, addresable: user, :billing }
  let(:shipping_address) { create :address, addresable: user, :shipping }
  
  before do
    sign_in create(:user)
    order.state = 'address'
    visit ('/checkouts')
    session['order_id'] = order.id
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit edit_user_registration_path
    expect(page).to have_current_path('/users/login')
  end
  
  context 'address information content' do
    scenario 'adress forms filled by present user addresses' do
      click_button 'Save and Continue'
    #   expect { click_button 'Save and Continue' }.to change{order.state}
    #   order.addresses.billings.attributes.except('id') == account2.attributes.except('id')
    #   expect(order.addresses.shipping).to be_present
    #   expect(order.addresses.billing).to be_present
      expect(page).to have_content('Shipping Method')
    end      
    scenario 'shipping addres filled by checkbox Use Billing Address' do
      shipping_address.destroy
      find(:css, ".billing-use").set(true)
      click_button 'Save and Continue'
      expect(page).to have_content('Shipping Method')
    end  
    scenario 'billing form not filled' do
      billing_address.destroy
      visit edit_user_registration_path
      find("button[name='billing']").click
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Phone can't be blank")
    end    
    scenario 'shipping form not filled' do
      shipping_address.destroy
      visit edit_user_registration_path
      find("button[name='shipping']").click
      expect(page).to have_content("First name can't be blank")
      expect(page).to have_content("Last name can't be blank")
      expect(page).to have_content("Address can't be blank")
      expect(page).to have_content("City can't be blank")
      expect(page).to have_content("Zip can't be blank")
      expect(page).to have_content("Phone can't be blank")
    end 
  end
 
end