feature 'Home page:' do
  let(:categories) { create_list :category, 3 }
  let(:order) { create :order }
  
  before do
    categories.each do |category|
      books_count = 5
      create_list [:product, :in_stock, :with_orders], books_count, category: category
    end
    session[:order_id] = order.id
    visit root_path
  end
  
  scenario 'located on home page' do
    page.status_code.should be 200
    expect(page).to have_current_path root_path
  end

  context 'main content' do
    scenario 'must present 2 newest products' do
      expect(page).to have_selector('.carousel-inner .item', count: 2)
    end
    scenario 'must present 4 bestsellers' do
      expect(page).to have_selector('.general-title', count: 4)
    end
  end

  context 'working buttons' do
    scenario 'add newest product to cart change total price of order' do
      expect { find('.btn-primary').first.click }.to change{order.total_price}
    end
    scenario 'add bestseller to cart change total price of order' do
      expect { find(:xpath, "//a/.fa-shopping-cart/..").click }.to change{order.total_price}
    end
    scenario 'show product' do
      find(:xpath, "//a/.fa-eye/..").click
      expect(page).to have_current_path(/products\/[0-9]+/)
    end
    scenario 'click Get Started button' do
      click_link 'Get Started'
      page.status_code.should be 200
      expect(page).to have_current_path('/products')
    end
  end
end