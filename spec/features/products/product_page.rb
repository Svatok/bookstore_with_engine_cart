feature 'products/show:' do
  let(:product) { create :product, :full_product }
  let(:reviews) { create_list :review, 4, product: product, :approved }
  let(:order) { create :order }
  
  before do
    session[:order_id] = order.id
    visit products_path(product.id)
  end
  
  scenario 'located on product page' do
    page.status_code.should be 200
    expect(page).to have_current_path('products/' + product.id.to_s)
  end

  context 'product content' do
    scenario 'must present title' do
      expect(page).to have_content(product.title)
    end
    scenario 'must present short description' do
      expect(page).to have_content(truncate(product.description, length: 170))
    end
    scenario 'must present authors' do
      expect(page).to have_content(product.all_authors)
    end
    scenario 'must present price' do
      expect(page).to have_content(product.price_value)
    end
    scenario 'must present other characteristics' do
      expect(page).to have_content(product.property_value('Year of publication'))
      expect(page).to have_content(product.property_value('Materials'))
      expect(page).to have_content(product.dimensions)
    end   
    scenario 'add product to cart change total price of order' do
      expect { click_button 'Add to Cart' }.to change{order.total_price}
    end
  end

  context 'reviews content' do
    scenario 'must present count of reviews' do
      expect(page).to have_content("Reviews (#{reviews.count})")
    end  
    scenario 'must present all reviews' do
      reviews_on_page = Array.new 
      reviews_on_page = find('.media-list ul').all('li')
      expect(reviews_on_page.count).to eq(reviews.count)
    end
  end
  context 'working form for new review' do
    scenario 'create new review' do
      fill_in 'product_review_product_id', with: product.id.to_s
      fill_in 'rate_value', with: "5"
      fill_in 'product_review_reviewer_name', with: "Test User"
      fill_in 'product_review_review_text', with: "Test Review for Product"
      expect { click_button 'Post' }.to change{product.reviews.count}.by(1)
    end
    scenario 'not valid product rate' do
      fill_in 'product_review_product_id', with: product.id.to_s
      fill_in 'rate_value', with: ""
      fill_in 'product_review_reviewer_name', with: "Test User"
      fill_in 'product_review_review_text', with: "Test Review for Product"
      click_button 'Post'
      expect(page).to have_content("Rate can't be blank")
    end
    scenario 'not valid reviewer name' do
      fill_in 'product_review_product_id', with: product.id.to_s
      fill_in 'rate_value', with: "5"
      fill_in 'product_review_reviewer_name', with: ""
      fill_in 'product_review_review_text', with: "Test Review for Product"
      click_button 'Post'
      expect(page).to have_content("Reviewer name can't be blank")
    end
    scenario 'not valid text of review' do
      fill_in 'product_review_product_id', with: product.id.to_s
      fill_in 'rate_value', with: "5"
      fill_in 'product_review_reviewer_name', with: "Test User"
      fill_in 'product_review_review_text', with: ""
      click_button 'Post'
      expect(page).to have_content("Review text can't be blank")
    end
  end  
end