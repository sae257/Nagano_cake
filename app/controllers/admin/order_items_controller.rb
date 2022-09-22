class Admin::OrderItemsController < ApplicationController
before_action :authenticate_admin!

  def update
    @order_item = OrderItem.find(params[:order_id])
    @order = @order_item.order
    if @order_item.update(order_item_params)
      if @order_item.production_status == "製作中"
        @order.update(status:2)
      elsif @order.order_items.count ==  @order.order_items.where(production_status: "製作完了").count
        @order.update(status:3)
      end
      redirect_to request.referer
    else
    end
  end

  private

  def order_item_params
    params.require(:order_item).permit(:production_status)
  end

end
