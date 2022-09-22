class Admin::ItemsController < ApplicationController

  def new
    @item = Item.new
    @genres = Genre.all
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def create
    @item = Item.new(item_params)
    if @item.save
      flash[:notice] = "商品を登録しました"
      redirect_to admin_item_path(@item)
    else
      flash[:notice] = "商品の登録に失敗しました"
      @genres = Genre.all
      @item = Item.new
      @search = Item.ransack(params[:q])
      @items = @search.result
      render :new
    end
  end

  def index
    @items = Item.page(params[:page])
    @search = Item.ransack(params[:q])
    @items = @search.result.page(params[:page])
  end

  def show
    @item = Item.find(params[:id])
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def edit
    @item = Item.find(params[:id])
    @genres = Genre.all
    @search = Item.ransack(params[:q])
    @items = @search.result
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(item_params)
      flash[:notice] = "商品登録情報を変更しました"
      redirect_to admin_item_path(@item)
    else
      flash[:notice] = "商品登録情報の変更に失敗しました"
      @genres = Genre.all
      @item = Item.new
      render :edit
    end
  end

  private

  def item_params
    params.require(:item).permit(:genre_id, :name, :image, :introduction, :price, :is_active)
  end

end
