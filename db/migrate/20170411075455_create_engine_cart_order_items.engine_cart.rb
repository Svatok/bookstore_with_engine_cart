# This migration comes from engine_cart (originally 20170328211419)
class CreateEngineCartOrderItems < ActiveRecord::Migration[5.0]
  def change
    create_table :engine_cart_order_items do |t|
      t.integer :product_id
      t.references :order, index: true
      t.float :unit_price
      t.integer :quantity

      t.timestamps
    end
  end
end
