feature 'products/show:' do
  let(:user) { create :user }
  let(:billing_address) { create :address, addresable: user, :billing }
  let(:shipping_address) { create :address, addresable: user, :shipping }
  
  before do
    sign_in create(:user)
    visit edit_user_registration_path
  end
  
  scenario 'located on user edit page' do
    page.status_code.should be 200  
    expect(page).to have_current_path('products/' + product.id.to_s)
  end

  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit edit_user_registration_path
    expect(page).to have_current_path('/users/login')
  end
  
  context 'address information content' do
    scenario 'billing form filled by present billing address' do
      find("button[name='billing']").click
      expect(page).to have_content('Address has been updated.')
    end      
    scenario 'billing form change field' do
      fill_in "address_forms_billing_first_name", with: 'BillingFirstNameNew'
      find("button[name='billing']").click
      expect(page).to have_content('BillingFirstNameNew')
    end  
    scenario 'shipping form filled by present shipping address' do
      find("button[name='shipping']").click
      expect(page).to have_content('Address has been updated.')
    end
    scenario 'shipping form change field' do
      fill_in "address_forms_shipping_first_name", with: 'ShippingFirstNameNew'
      find("button[name='shipping']").click
      expect(page).to have_content('ShippingFirstNameNew')
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

  context 'main information content' do
    scenario 'email field filled by present email' do
      expect(page).to have_content(user.email)
    end
    scenario 'change email' do
      fill_in "user_email", with: 'newuseremail@example.com'
      find("button[name='commit']").click
      expect(page).to have_content('Your account has been updated successfully.')
    end
    scenario 'change password' do
      fill_in "user_current_password", with: 'TestPassword2017'
      fill_in "user_password", with: 'TestPassword2017New'
      fill_in "user_password_confirmation", with: 'TestPassword2017New'
      find("button[name='commit']").click
      expect(page).to have_content('Your account has been updated successfully.')
    end
  end  
end