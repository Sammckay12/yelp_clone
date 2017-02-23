class RestaurantsController < ApplicationController

before_action :authenticate_user!, :except=> [:index, :show]

  def index
    @restaurants = Restaurant.all
  end

  def new
    @restaurant = current_user.restaurants.new
  end

  def create
    @restaurant = current_user.restaurants.new(restaurant_params)
    if @restaurant.save
      redirect_to restaurants_path
    else
      render 'new'
    end
  end


  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      render 'edit'
    else
      flash[:notice] = 'You cannot edit restaurants created by another user'
      redirect_to restaurants_path
    end
  end

  def update
    @restaurant = current_user.restaurants.find(params[:id])
    @restaurant.update(restaurant_params)
    redirect_to '/restaurants'
  end

  def destroy
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.user_id == current_user.id
      @restaurant.destroy
      flash[:notice] = 'You have deleted restaurant successfully'
    else
      flash[:notice] = 'You cannot delete restaurants created by another user'
    end
    redirect_to '/restaurants'
  end

  private


  def restaurant_params
    params.require(:restaurant).permit(:name, :description)
  end

end
