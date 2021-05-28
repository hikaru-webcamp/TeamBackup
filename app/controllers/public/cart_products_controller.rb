class Public::CartProductsController < ApplicationController
  before_action :authenticate_customer!
  def index
    @cart_products = CartProduct.where(customer_id: current_customer.id)
    @cart_products = current_customer.cart_products
    @total_price = 0
    @cart_products.each do |cart_product|
      @total_price += cart_product.product.tax_price * cart_product.quantity
    end
  end

  def create
    cart_product = CartProduct.new(cart_product_params)
    cart_product.customer_id = current_customer.id
    in_cart_product = CartProduct.find_by(product_id: cart_product.product_id, customer_id: current_customer.id)
    if in_cart_product.present?
      in_cart_product.quantity += cart_product.quantity
      in_cart_product.save
    else
      cart_product.save
    end
    redirect_to(cart_products_path, notice: "カートに追加しました")
  end

  def update
    cart_product = CartProduct.find(params[:id])
    if cart_product.customer_id == current_customer.id
      if cart_product.update(cart_product_params)
        flash[:notice] = "商品の個数を変更しました"
      else
        flash[:alert] = "商品個数の変更に失敗しました"
      end
    end
    redirect_to cart_products_path
  end

  def destroy
    cart_product = CartProduct.find(params[:id])
    if cart_product.customer_id == current_customer.id
      cart_product.destroy
    end
    redirect_to cart_products_path, alert: "カートから商品を削除しました"
  end

  def destroy_all
    cart_products = CartProduct.where(customer_id: current_customer.id)
    byebug
    cart_products.destroy_all
    redirect_to cart_products_path, alert: "カートを空にしました"
  end

  private

  def cart_product_params
    params.require(:cart_product).permit(:product_id, :quantity)
  end
end
