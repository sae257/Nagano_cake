class Public::AddressesController < ApplicationController
before_action :authenticate_customer!

  def index
    @addresses = Address.all
    @address = Address.new
    @search = Item.ransack(params[:q])
    @items = @search.result
  end


  def create
    @address = Address.new(address_params)
    @address.customer_id = current_customer.id
    @addresses = Address.all
    if @address.save
       flash.now[:notice] = "新規配送先を登録しました"
       redirect_to addresses_path
    else
       @addresses = Address.all
       render 'index'
    end
  end

  def edit
    @address = Address.find(params[:id])
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def update
    @address = Address.find(params[:id])
    if @address.update(address_params)
       flash[:success] = "配送先を変更しました"
       redirect_to addresses_path
    else
       render "edit"
    end
  end

  def destroy
    @address = Address.find(params[:id])
    @address.destroy
    @addresses = Address.all
    flash[:alert] = "配送先を削除しました"
    redirect_to addresses_path
  end

  private

  def address_params
    params.require(:address).permit(:post_code, :address, :name)
  end

end
