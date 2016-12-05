class SessionsController < ApplicationController
  def new
  end
  
  def create
    #ユーザをメールアドレスから探す
    @user = User.find_by(email: params[:session][:email].downcase)
    #ユーザが見つかった場合、authenticateメソッドでパスワードが正しいかチェック
    if @user && @user.authenticate(params[:session][:password])
      #正→session[:user_id]にユーザIDを入れて、詳細ページに移動
      session[:user_id] = @user.id
      flash[:info] = "logged in as #{@user.name}"
      redirect_to @user
    else
      flash[:danger] = 'invalid email/password combination'
      render 'new'
    end
  end
    
  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end
