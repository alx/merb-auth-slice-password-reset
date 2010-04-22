class MerbAuthSlicePasswordReset::Passwords <  MerbAuthSlicePasswordReset::Application

  def forgot_password
    @login_param_name = Merb::Authentication::Strategies::Basic::Base.login_param
    render
  end
  
  def send_confirmation
    @login_param_name = Merb::Authentication::Strategies::Basic::Base.login_param
    @user = Merb::Authentication.user_class.find_with_login_param(@login_param_name, params[@login_param_name])
    if @user
      @user.send_password_reset_notification
      redirect_after_sending_confirmation
    else
      message[:error] = "User with #{@login_param_name} \"%s\" not found".t(params[@login_param_name].freeze)
      render :forgot_password
    end
  end

  def reset
    @user = Merb::Authentication.user_class.find_with_password_reset_code(params[:password_reset_code])
    raise NotFound if @user.nil?
    render
  end

  def reset_check
    @user = Merb::Authentication.user_class.find_with_password_reset_code(params[:password_reset_code])
    # FIXME: This only works for DataMapper right now.  I assume that the ActiveORM abstraction
    #        will have a method that works for all ORMs.
    raise NotFound if @user.nil?
    if @user.update(params[:user])
      redirect_after_password_reset
    else
      message[:error] = @user.errors.map { |e| e.to_s }.join(" and ") if @user.errors
      render :reset
    end
  end

  private

  def redirect_after_password_reset
    redirect "/", :message => {:notice => "Your password has been changed".t}
  end
  
  def redirect_after_sending_confirmation
    redirect "/", :message => {:notice => "Password reset confirmation sent".t}
  end

end # MerbAuthSlicePasswordReset::Passwords
