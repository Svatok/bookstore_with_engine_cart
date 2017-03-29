feature 'products/show:' do
  let(:user) { create :user }
  let(:order) { create :order }
  let(:order_items) { create_list :order_items, 2, order: order }
  let(:coupon) { create :product, :coupon }
  
  before do
    visit cart_path
    session['order_id'] = order.id
    visit cart_path
  end
  
  scenario 'located on cart page' do
    page.status_code.should be 200
    expect(page).to have_current_path('/cart')
  end
  
  context 'cart content' do
    scenario 'must present order_items' do
      order_items.each do |order_item|
        expect(page).to have_content(order_item.product.title)
      end
    end
    scenario 'cart total price must equal sum(count * unit_price) of order_items' do
      total_price = 0
      order_items.each do |order_item|
        total_price += order_item.unit_price * order_item.quantity
      end
      expect(page).to have_content(total_price.to_s)
    end
    scenario 'update cart with coupon' do
      fill_in 'coupon_code', with: coupon.title
      expect { click_button 'Update cart' }.to change{order.total_price}
      expect(page).to have_content((coupon.price * -1).to_s)
    end
    scenario 'update cart with add quantity of order item' do
      fill_in 'order_items_' + order_items.first.id.to_s + '_quantity', with: '3'
      expect { click_button 'Update cart' }.to change{order.total_price}
    end
    scenario 'delete item from cart' do
      expect { find('.general-cart-close').first.click }.to change{order.total_price}
    end
  end

  scenario 'go to checkout' do
    click_button 'Checkout'
    page.status_code.should be 200
    expect(page).to have_current_path('/checkouts')
  end
  
 end