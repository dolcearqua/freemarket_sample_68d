class ItemsController < ApplicationController
  before_action :set_item, except: [:new, :create, :index]
  def index
    @items = Item.includes(:images).order('created_at DESC')
  end

  def new
    @item = Item.new
    @item.images.new
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      redirect_to items_path
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @item.update(item_params)
      redirect_to items_path
    else
      render :edit
    end
  end

  def show
    @images = @item.images
    @categories = Category.all
  end 

  def get_category_children
    @category_children = Category.find(params[:productcategory]).children
  end

  def get_category_grandchildren
    @category_grandchildren = Category.find(params[:productcategory]).children
  end
end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_item
    @item = Item.find(params[:id])
  end

  def item_params
    params.require(:item).permit(
      :name, 
      :explaination,
      :status_id,
      :delivery_charge_flag,
      :prefecture_id,
      :delivery_date_id,
      :price, 
      images_attributes: [
        :id,
        :image
      ]
    )
    # userの登録機能実装が完了したら生かす
    # .merge(user_id: current_user.id)
  end
