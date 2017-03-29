feature '/products' do
  let(:categories) { create_list :category, 3 }
  let(:order) { create :order }
  
  before do
    categories.each do |category|
      books_count = 3
      create_list [:product, :in_stock], books_count, category: category
    end
    session[:order_id] = order.id
    visit products_path
  end
  
  scenario 'located in catalog' do
    page.status_code.should be 200
    expect(page).to have_current_path '/products'
  end

  context 'main content' do
    scenario 'count of products < max visible products at page' do
      expect(page).to have_selector('.general-title', count: 9)
      expect(find('.btn-primary', :text => 'Next Page')).not_to be_present
    end
    scenario 'count of products > max visible products at page' do
      categories.each do |category|
       books_count = 3
       create_list [:product, :in_stock], books_count, category: category
     end
      expect(page).to have_selector('.general-title', count: 12)
      expect(find('.btn-primary', :text => 'Next Page')).to be_present
    end
    scenario 'must present scoups by categories' do    
      categories.map(&:name).each do |name|
        expect(find('.filter-link', :text => name)).to be_present
      end
    end
  end

  context 'working buttons' do
    scenario 'add product to cart change total price of order' do
      expect { find(:xpath, "//a/.fa-shopping-cart/..").click }.to change{order.total_price}
    end
    scenario 'show product' do
      find(:xpath, "//a/.fa-eye/..").click
      expect(page).to have_current_path(/products\/[0-9]+/)
    end
  end
end