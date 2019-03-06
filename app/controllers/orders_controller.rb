class OrdersController < ApplicationController

  before_action :set_order, only: [:show, :update, :destroy]
  skip_before_action :authenticate_user!

  def index
    @orders = Order.all
    render json: @orders
  end

  def show
    render json: @order
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      render json: @order, status: :created
    else
      render json: @order.errors
    end
  end

  def update
    if @order.update(order_params)
      render json: @order
    else
      render json: @order.errors, stauts: :unprocessable_entity
    end
  end

  def destroy
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
      :status
    )
  end

end
