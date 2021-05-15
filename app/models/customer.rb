class Customer < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  has_many :cart_products, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :orders, dependent: :destroy


  # 全角カタカナと長音符にマッチする正規表現
  KATAKANA_REGEXP = /\A[\p{katakana}\u{30fc}]+\z/

  #バリデーションの記述(空でないこと)
  validates :last_name,  presence: true
  validates :first_name, presence: true
  validates :last_name_kana, presence: true, format: { with: KATAKANA_REGEXP, message: "全角カタカナのみで入力して下さい" }
  validates :first_name_kana, presence: true, format: { with: KATAKANA_REGEXP, message: "全角カタカナのみで入力して下さい" }
  validates :email, presence: true
  validates :postal_code,  presence: true
  validates :address, presence: true
  validates :tel, presence: true

end
