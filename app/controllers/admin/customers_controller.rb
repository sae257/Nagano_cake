class Admin::CustomersController < ApplicationController
  def index
    @customers = Customer.all
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def show
    @customer = Customer.find(params[:id])
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def edit
    @customer = Customer.find(params[:id])
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def update
    @customer = Customer.find(params[:id])
    @customer.update(customer_params)
    redirect_to admin_customer_path(@customer.id)
  end
  
  def search_order
    @genres = Genre.all
    @customer = Customer.find(params[:id])
    @customerorders = Order.where(customer_id: @customer.id)
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  private

  def customer_params
    params.require(:customer).permit(:family_name, :first_name, :family_name_kana, :first_name_kana, :post_code, :phone, :address, :is_deleted)
  end
end
