class SignupController < ApplicationController
  def create
    user = User.new(user_params)
    if user.save
      #Carga útil
      payload  = { user_id: user.id } 
      #Criando novo tokenusando payload e JWTSessions
      session = JWTSessions::Session.new(payload: payload, refresh_by_access_allowed: true)
      tokens = session.login
      #Settando Cookie
      response.set_cookie(JWTSessions.access_cookie,
                          value: tokens[:access],
                          httponly: true,
                          secure: Rails.env.production?)
      render json: { csrf: tokens[:csrf] }
    else
      render json: { error: user.errors.full_messages.join(' ') }, status: :unprocessable_entity
    end
  end

  private
  def user_params
    params.permit(:email, :password, :password_confirmation)
  end

end
