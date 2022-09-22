class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy

  def full_name1
    self.family_name + self.first_name
  end

  def full_name
    self.family_name + " " + self.first_name
  end

  def full_name_kana
    self.family_name_kana + " " + self.first_name_kana
  end

end
