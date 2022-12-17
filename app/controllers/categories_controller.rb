class CategoriesController < ApplicationController
  before_action :require_admin, except: %i[index show]

  def new
    @category = Category.new
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 3)
  end

  def show
    @category = Category.find(params[:id])
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      flash[:notice] = 'Category was successfully created'
      redirect_to @category
    else
      render 'new', status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def require_admin
    return if logged_in? && current_user.admin?

    flash[:alert] = 'Only admin users are allowed to perform this action.'
    redirect_to categories_path
  end
end
