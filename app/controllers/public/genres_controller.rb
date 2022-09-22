class Public::GenresController < ApplicationController
  def show
    @genres = Genre.all
    @genre = Genre.find(params[:id])
    @genreitems = Item.where(genre_id: @genre.id).page(params[:page])
    @search = Item.ransack(params[:q])
    @items = @search.result
  end
end
