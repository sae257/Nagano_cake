class Address < ApplicationRecord
  belongs_to :customer

  def full_adresses
      post_code + address + name
  end
end
