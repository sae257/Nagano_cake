class Public::OrdersController < ApplicationController
  before_action :authenticate_customer!

  def new
    @order = Order.new
    @addresses = current_customer.addresses.all
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def confirm
    @order = Order.new(order_params)
    @cart_items = current_customer.cart_items
    @order.postage = 800
    @total = @cart_items.inject(0) { |sum, item| sum + item.subtotal }
    if  params[:order][:address_option] == "0"
        @order.shipping_post_code = current_customer.post_code
        @order.shipping_address = current_customer.address
        @order.shipping_name = current_customer.family_name + current_customer.first_name
        @order.payment_method = params[:order][:payment_method]

    elsif  params[:order][:address_option] == "1"
        ship = Address.find(params[:order][:customer_id])
        @order.shipping_post_code = ship.post_code
        @order.shipping_address = ship.address
        @order.shipping_name = ship.name

    elsif params[:order][:address_option] = "2"
        @order.shipping_post_code = params[:order][:shipping_post_code]
        @order.shipping_address = params[:order][:shipping_address]
        @order.shipping_name = params[:order][:shipping_name]
        @order.payment_method = params[:order][:payment_method]
    else
        render 'new'
    end
    @cart_items = current_customer.cart_items.all
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @cart_items = current_customer.cart_items.all
    @order.save

    @cart_items  = current_customer.cart_items
    @cart_items.each do |cart_item|
    @ordered_item = OrderItem.new
    @ordered_item.item_id = cart_item.item_id
    @ordered_item.quantity = cart_item.quantity
    @ordered_item.purchase_price = cart_item.item.add_tax_price
    @ordered_item.order_id =  @order.id
    @ordered_item.save
  end
   redirect_to thanks_orders_path
   current_customer.cart_items.destroy_all
  end

  def thanks
    @search = Item.ransack(params[:q])
    @items = @search.result
    @item = Item.order("RANDOM()").limit(3)
  end

  def index
    @orders = current_customer.orders
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def show
    @order = Order.find(params[:id])
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  private

  def order_params
    params.require(:order).permit(:customer_id, :total_price, :payment_method, :postage, :shipping_post_code, :shipping_address, :shipping_name, :status)
  end
end
