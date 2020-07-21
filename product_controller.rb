class ProductsController < ApplicationController
    include CurrentCart
    include Pagy::Backend
    before_action :set_product, only: [:show, :edit, :update, :destroy, :hovercard]
    before_action :set_cart, only: [:index]
    # GET /products
    # GET /products.json
    def index
      @already_in_cart = LineItem.where(cart_id: session[:cart_id]).pluck(:product_id, :quantity)
      @line_items_info_sum = get_cart_summary
      if params[:search_any].nil? || params[:search_any].empty?
        @pagy, @products = pagy(Product.includes(:pricelists)
                                       .where(pricelists: { price_list: current_user.price_list })
                                       .with_attached_image)
      else
        @pagy, @products = pagy(Product.search_any(params[:search_any])
                                       .includes(:pricelists)
                                       .where(pricelists: { price_list: current_user.price_list })
                                       .with_attached_image)
      end
  
      @line_item = LineItem.new
  
      respond_to do |format|
        format.html
        format.json {
          render json: { entries: render_to_string(partial: "products", formats: [:html]), pagination: view_context.pagy_bulma_nav(@pagy)}
        }
      end
    end
  
    # GET /products/1
    # GET /products/1.json
    def show
    end
  
    # GET /products/new
    def new
      @product = Product.new
    end
  
    # GET /products/1/edit
    def edit
    end
  
    # POST /products
    # POST /products.json
    def create
      @product = Product.new(product_params)
  
      respond_to do |format|
        if @product.save
          format.html { redirect_to @product, notice: 'Product was successfully created.' }
          format.json { render :show, status: :created, location: @product }
        else
          format.html { render :new }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PATCH/PUT /products/1
    # PATCH/PUT /products/1.json
    def update
      respond_to do |format|
        if @product.update(product_params)
          format.html { redirect_to @product, notice: 'Product was successfully updated.' }
          format.json { render :show, status: :ok, location: @product }
        else
          format.html { render :edit }
          format.json { render json: @product.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /products/1
    # DELETE /products/1.json
    def destroy
      @product.destroy
      respond_to do |format|
        format.html { redirect_to products_url, notice: 'Product was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  
    def hovercard
      render layout: false
    end
  
    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.find(params[:id])
      end
  
      # Only allow a list of trusted parameters through.
      def product_params
        params.require(:product).permit(:search_any,
                                        :item_code,
                                        :item_name,
                                        :code_bars,
                                        :item_size,
                                        :item_size_unit,
                                        :items_per_case,
                                        :case_volume,
                                        :case_volume_unit,
                                        :case_weight,
                                        :case_weight_unit,
                                        :max_shelf_life,
                                        :image)
      end
end
  