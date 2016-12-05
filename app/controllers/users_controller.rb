class UsersController < ApplicationController
  #ログインしているユーザーが自分の編集画面のみに編集・更新を限定する
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]
  
  #ユーザーが情報を入力してログインした後の画面
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.order(created_at:  :desc)
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user  # redirect_to user_path(@user)と同じ
    else
      render 'new'
    end
  end
  
  def edit
    #userへの代入文を削除  
    @user = User.find(params[:id])
  end
  
  def update
    #userへの代入文を削除  
    @user = User.find(params[:id])
    #user_attributesを使って送信されたparamsに基づいてユーザを更新
    if @user.update_attributes(user_params)
      redirect_to @user
      flash[:success] = "Updated" 
    else
      render 'edit'
    end
  end

  private
  
  def user_params
    params.require(:user).permit(:name,:location,:email,:password,
                                 :password_confirmation)
  end
  
  #beforeフィルター
    
  def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
  
  #正しいユーザーかどうか
  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless @user == current_user
  end  
end