class OrdersController < ApplicationController
  before_filter :check_logged_in

  def new
    @order = Order.new
  end

  def index
    @orders = Order.search(params[:search], current_user)
  end

  def create
    @order = Order.new
    @order.user = current_user
    @order.billing_address = Address.new(params[:order][:billing_address])
    @order.shipping_address = Address.new(params[:order][:shipping_address])
    @order.credit_cards << CreditCard.new(params[:order][:credit_card])
    @order.add_products_by_cart_id(params[:order][:cart_id])

    if @order.save
      params[:order] = @order.to_param
      redirect_to order_path(@order)
    else
      render :action => 'create', :notice => "Something went wrong."
    end
  end

  def show
    @order = current_user.orders.find_by_id(params[:id])
    unless @order
      redirect_to root_url, :notice => "DON'T TOUCH THAT"
    end
  end

end
