# This migration comes from engine_cart (originally 20170328210716)
class CreateEngineCartOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :engine_cart_orders do |t|
      t.integer :user_id, index: true
      t.float :total_price
      t.string :state
      t.string :prev_state
      t.string :order_number
      t.date :placed_date

      t.timestamps
    end
  end
end
