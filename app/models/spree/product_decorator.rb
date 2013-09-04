Spree::Product.class_eval do
  def on_sale?
    master.on_sale?
  end

  def on_sale=(value)
    master.on_sale = value
  end
end