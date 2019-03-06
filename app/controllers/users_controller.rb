class UsersController < ApplicationController

  before_action :set_user, only: [:show, :update, :destroy]

  def index
    # authorize @user
    @users = User.all
    render json: @users
  end

  def show
    # authorize @user #volta?
    render json: @user
  end

  def create
    # authorize @user
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
     render json: @user.errors
    end
  end

  def update
    # authorize @user # volta?
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  def destroy
    # destroy não será utilizado, pois os orders terão users vinculados, 
    # o que impossibilita a exclusão do user, sem contar a questão dos relatórios
    # authorize @user # volta?
    @user.destroy
    head :no_content
  end


  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(
      :id,
      :name, 
      :role, 
      :email,
      :password
    )
  end

end
