# This migration comes from engine_cart (originally 20170328212200)
class CreateEngineCartPayments < ActiveRecord::Migration[5.0]
  def change
    create_table :engine_cart_payments do |t|
      t.string :card_number
      t.string :name_on_card
      t.string :mm_yy
      t.integer :cvv
      t.references :order, index: true

      t.timestamps
    end
  end
end
