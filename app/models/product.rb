class Product < ApplicationRecord
  belongs_to :genre
  has_many :cart_products, dependent: :destroy
  has_many :order_details, dependent: :destroy

#画像アップ用のメソッド（attachment）を追加
  attachment :image

#バリデーションの記述(空でないこと)
  validates :name, presence: true
  validates :price, presence: true
  
end
