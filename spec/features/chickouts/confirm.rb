feature 'products/show:' do
  let(:user) { create :user }
  let(:order) { create :order }
  let(:order_items) { create_list :order_items, 2, order: order }
  let(:payment) { create :payment, order: order }
  let(:shipping) { create :order_item, order: order, :shipping }
  let(:billing_address) { create :address, addresable: order, :billing }
  let(:shipping_address) { create :address, addresable: order, :shipping } 
  
  before do
    sign_in user
    order.state = 'payment'
    visit ('/checkouts')
    session['order_id'] = order.id
  end

   background do
    clear_emails
    visit email_trigger_path
    open_email(user.email)
  end
  
  scenario 'redirect to Log In if user is unauthorized' do
    logout(:user)
    visit edit_user_registration_path
    expect(page).to have_current_path('/users/login')
  end
  
  context 'order confirm content' do
    scenario 'must present short billing address' do
      expect(page).to have_content(billing_address.firs_name)
      expect(page).to have_content(billing_address.last_name)
      expect(page).to have_content(billing_address.address)
      expect(page).to have_content(billing_address.city)
      expect(page).to have_content(billing_address.countries.name)
      expect(page).to have_content(billing_address.zip)
      expect(page).to have_content(billing_address.phone)
    end     
    scenario 'must present short shipping address' do
      expect(page).to have_content(shipping_address.firs_name)
      expect(page).to have_content(shipping_address.last_name)
      expect(page).to have_content(shipping_address.address)
      expect(page).to have_content(shipping_address.city)
      expect(page).to have_content(shipping_address.countries.name)
      expect(page).to have_content(shipping_address.zip)
      expect(page).to have_content(shipping_address.phone)
    end  
    scenario 'must present short shipment information' do
      expect(page).to have_content(shipping.title)
      expect(page).to have_content(shipping.description)
    end 
    scenario 'must present short payment information' do
      expect(page).to have_content(payment.mm_yy)
      expect(page).to have_content(payment.card_number.last(4))
    end     
    
    scenario 'must present edit information links' do
      expect(page).to have_css(".general-edit", count: 4)
    end
    scenario 'must present short shipping address' do
      expect(page).to have_content("Shipping Address")
    end      
    scenario 'must present short billing address' do
      expect(page).to have_content("Billing Address")
    end 
    scenario 'must present shipment information' do
      expect(page).to have_content("Shipments")
    end 
    scenario 'must present payment inaormation' do
      expect(page).to have_content("Payment Information")
    end 
    scenario 'must present order items' do
      expect(page).to have_selector("tr", count:2)
      order_items.products.main.each do |product|
        expect(page).to have_content(product.title)
      end
    end
    scenario 'redirect to comlete page after confirm' do
      click_button 'Save and Continue'
      expect(page).to have_content("Choose delivery!")
    end
    scenario 'send letter after confirm' do
      click_button 'Save and Continue'
      expect(current_email).to have_content order.order_number
    end
  end

 
end