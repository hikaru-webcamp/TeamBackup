class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!
  def show
    @customer = current_customer
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
      redirect_to my_page_customers_path, notice: "会員情報を変更しました"
    else
      render :edit
    end
  end

  def out
    @customer = current_customer
    @customer.update(is_deleted: true)
    reset_session #ログアウト
    redirect_to root_path, alert: "退会しました"
  end

  def out_confirm
  end

  private
  def customer_params
    params.require(:customer).permit(
      :first_name, :last_name, :first_name_kana, :last_name_kana, :postal_code, :address, :tel, :email )
  end
end
