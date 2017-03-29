feature 'menu' do
  let(:categories) { create_list :category, 3 }
  before { visit root_path }
  
  context 'link to Home' do
    before do
        create_list :category, 3
        categories.first.default_sort = true
    end
    scenario 'link must present' do
      expect(page).to have_content 'Home'
    end
    scenario 'under link menu with categories must present' do
     categories.map(&:name).each do |category|
        expect(page).to have_content name
      end
    end
    scenario 'category link redirect to home page with sort by category parameter' do
      category = categories.first
      click_link category.name
      page.status_code.should be 200
      expect(page).to have_current_path('/?category=' + category.id.to_s)
    end
  end
  
  context 'link to Shop' do
    scenario 'link must present' do
      expect(page).to have_content 'Shop'
    end
    scenario 'link redirect to catalog page' do
      click_link 'Shop'
      page.status_code.should be 200
      expect(page).to have_current_path('/products')
    end
  end  
  
  context 'guest visit' do
    scenario 'must present Log In button' do
      expect(page).to have_content 'Log In'
    end
    scenario 'Log In link redirect to Log In page' do
      click_link 'Log In'
      page.status_code.should be 200
      expect(page).to have_current_path('/users/login')
    end
    scenario 'must present Sign Up button' do
      expect(page).to have_content 'Sign Up'
    end
    scenario 'Sign Up link redirect to Sign Up page' do
      click_link 'Sign Up'
      page.status_code.should be 200
      expect(page).to have_current_path('/users/sign_up')
    end
  end

  context 'signed user visit' do  
    before { sign_in create(:user) }

    scenario 'link to My account must present' do
      expect(page).to have_content 'My account'
    end
    scenario 'under link My account must present link to Orders' do
      expect(page).to have_content 'Orders'
    end
    scenario 'link Orders redirect to users`s orders' do
      click_link 'Orders'
      page.status_code.should be 200
      expect(page).to have_current_path('/orders')
    end
    scenario 'under link My account must present link to Settings' do
      expect(page).to have_content 'Settings'
    end
    scenario 'link Settings redirect to users`s settings' do
      click_link 'Settings'
      page.status_code.should be 200
      expect(page).to have_current_path('/users/edit')
    end
    scenario 'under link My account must present link Log out' do
      expect(page).to have_content 'Log out'
    end
    scenario 'link Log out clear user`s session' do
      click_link 'Log out'
      page.status_code.should be 200
      current_user.should be_nil
    end
  end
  
  context 'link to Cart' do
    let(:order) { create :order, :with_items }
    
    scenario 'link must present' do
      expect(page).to have_selector('.shop-icon')
    end
    scenario 'link redirect to Cart page' do
      find('.shop-icon').click
      page.status_code.should be 200
      expect(page).to have_current_path('/cart')
    end
    scenario 'not show count of products in cart when cart empty' do
      shop_quantity = find('.shop-quantity')
      expect(shop_quantity).not_to be_present
    end
    scenario 'show count of products in cart when cart not empty' do
      session[:order_id] = order.id
      visit root_path
      shop_quantity = find('.shop-quantity', :text => order.order_items.count.to_s)
      expect(shop_quantity).to be_present
    end
  end 
 
end