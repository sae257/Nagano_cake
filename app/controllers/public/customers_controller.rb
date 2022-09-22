class Public::CustomersController < ApplicationController
  before_action :authenticate_customer!

  def show
    @customer = current_customer
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def unsubscribe
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def withdrawal
    @customer = current_customer
    @customer.update(is_deleted: true)
  reset_session
    flash[:notice] = "ありがとうございました。またのご利用をお待ちしております"
    redirect_to root_path
  end

  def edit
    @customer = current_customer
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
       flash[:success] = "登録情報を変更しました"
       redirect_to customers_my_page_path
    else
       render :edit and return
    end
  end

  private

  def customer_params
    params.require(:customer).permit(:email,:family_name,:first_name,:family_name_kana,:first_name_kana,:post_code,:address,:phone)
  end


end
