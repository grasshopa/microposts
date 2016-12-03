class UsersController < ApplicationController
  
  #ユーザーが情報を入力してログインした後の画面
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user  # redirect_to user_path(@user)と同じ
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    #user_attributesを使って送信されたparamsに基づいてユーザを更新
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:success] = "updated" 
    else
      render 'edit'
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name,:email,:password,
                                 :password_confirmation)
  end
end