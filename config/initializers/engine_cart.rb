EngineCart.setup do |config|
  # Define person class
  config.person_class = 'User'

  # Define product class
  config.product_class = 'Product'

  # Define product price
  config.product_price = 'prices.actual.first.value'

end