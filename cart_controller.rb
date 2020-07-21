class CartsController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:edit, :update, :destroy]
  before_action :set_cart_view, only:[:show]

  def index
    @carts = Cart.all
  end

  def show
    @cart
    @line_items_info_sum = get_cart_summary(params[:id])
  end

  def new
    @cart = Cart.new
  end

  def edit
  end

  def create
    @cart = Cart.new(cart_params)

    respond_to do |format|
      if @cart.save
        format.html { redirect_to @cart, notice: 'Cart was successfully created.' }
        format.json { render :show, status: :created, location: @cart }
      else
        format.html { render :new }
        format.json { render json: @cart.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
      if @cart.update!(customer_ref: params[:cart][:customer_ref],
                       requested_eta: arrival_date(params[:cart][:requested_eta]),
                       comments: params[:cart][:comments],
                       files: params[:cart][:files],
                       processed: true
                      )
        CartMailer.with(cart: @cart).request_quote.deliver_later
        session[:cart_id] = nil
        redirect_to @cart, notice: 'Cart was successfully updated.'
      else
        render :edit, notice: 'Your order is empty!', status: :unprocessable_entity
      end
  end

  def destroy
    @cart.destroy
    respond_to do |format|
      format.html { redirect_to carts_url, notice: 'Cart was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_cart
      @cart = current_user.carts.find(params[:id])
    end

    def set_cart_view
      @cart = current_user.carts.includes({ line_items: [:product] }).order('products.item_name').find_by(id: params[:id])
    end

    # Only allow a list of trusted parameters through.
    def cart_params
      #params.fetch(:cart, {})
      params.require(:cart).permit(:customer_ref, :requested_eta, :comments, files: [])
    end

    def arrival_date(date)
      Date.strptime(date,"%m/%d/%Y")
    rescue Date::Error => e
      45.days.from_now
    end
end
