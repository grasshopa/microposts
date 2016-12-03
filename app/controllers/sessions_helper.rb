module SessionsHelper
	def current_user
		#session[:user_id]に一致するユーザがある→@current_userに現在のユーザが入り、
		#一致しない→nilが入る
		@current_user ||= User.find_by(id: session[:user_id])
	end
	
	#※logged_inメソッド、「!!」右側が存在→true、nil→falseを返す
	def logged_in?
		!!current_user
	end
	
	#リクエストがGETの場合は、session[:forwarding_url]にリクエストのURLを代入するメソッド
    #ログインが必要なページにアクセスしようとした際に、ページのURLを一旦保存しておき、
    #ログイン画面に遷移してログイン後に再び保存したURLにアクセスする場合に使用
	def store_location
		session[:forwarding_url] = request.url if request.get?
	end
end