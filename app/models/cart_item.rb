class CartItem < ApplicationRecord
  belongs_to :customer
  belongs_to :item

  def subtotal
    item.add_tax_price * quantity.to_i
  end
end
