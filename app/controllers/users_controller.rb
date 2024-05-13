class UsersController < ApplicationController

  def current_user
    if session[:user_id]
      User.find { |u| u.id == session[:user_id] }
    else
      nil
    end
  end

  def sign_out
    session.clear
    redirect_to '/users/sign_in'
  end

  def index
    if session[:user_id]
      redirect_to '/'
    end
  end

  def sign_in
    if session[:user_id]
      redirect_to '/'
    end
  end

  def send_sign_in
    @user = User.find { |u| u.name == params[:name] }

    if @user && test_password(params[:password], @user.password)
      session.clear
      session[:user_id] = @user.id

      redirect_to '/'

    else
      flash.alert = "Incorrect username or password!"
      redirect_to '/users/sign_in'
    end
  end

  def create
    @user = User.new("name" => params["name"], "password" => hash_password(params["password"]))

    begin
      saved_user = @user.save
      redirect_to '/users/sign_in'
    rescue Exception => e
      flash.alert = "This username is already taken!"
      redirect_to '/users'

    end
  end

  #we are going to use this to hash passwords before we save them
  def hash_password(password)
    Digest::SHA2.digest(password.to_s).force_encoding('UTF-8')
  end

  #we are going to use this to compare passwords to already saved hashes
  def test_password(password, hash)
    Digest::SHA2.digest(password.to_s).force_encoding('UTF-8') == hash
  end

end
