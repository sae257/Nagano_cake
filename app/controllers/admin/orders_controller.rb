class Admin::OrdersController < ApplicationController
before_action :authenticate_admin!

  def show
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def update
    @order = Order.find(params[:id])
    @order_items = @order.order_items
    @order.update(order_params)
    if @order.status == "入金確認"
      @order_items.update_all(production_status: 1)
      redirect_to  request.referer
    else
      redirect_to request.referer
    end
  end

  private

  def order_params
    params.require(:order).permit(:status)
  end

end
