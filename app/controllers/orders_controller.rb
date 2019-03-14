class OrdersController < ApplicationController

  before_action :set_order, only: [:show, :update, :destroy]

  def index
    @orders = Order.all
    render json: @orders, include: :order_item
  end

  def show
    render json: @order, include: :order_item
  end

  def create
    @order = Order.new(order_params.merge(user_id: current_user.id))
    if @order.save
      render json: @order, include: :order_item, status: :created
    else
      render json: @order.errors
    end
  end

  def update
    if @order.update(order_params)
      render json: @order, include: :order_item
    else
      render json: @order.errors, stauts: :unprocessable_entity
    end
  end

  def destroy
    authorize current_user
    raise "Order can only be deleted if it has the canceled status" unless ( @order.status == "canceled" )
    @order.destroy
    head :no_content
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(
      :contact_id,
      :status,
      :order_type,
      :order_item_attributes => [:product_id, :quantity, :item_price, :id, :_destroy]
    )
  end

end
