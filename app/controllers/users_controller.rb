#UsersController
#Analitical Forecasting System
#aqueelone@gmail.com
class UsersController < ApplicationController
before_action :set_user, only: [:show, :edit, :update, :destroy]

  def index
    redirect to: user_omniauth_authorize_path(provider: vkontakte)
  end
  # GET /users/:id.:format
  def show
    # authorize! :read, @user
  end

  # GET /users/:id/edit
  def edit
    # authorize! :update, @user
  end

  # PATCH/PUT /users/:id.:format
  def update
    # authorize! :update, @user
    respond_to do |format|
      if @user.update(user_params)
        sign_in(@user == current_user ? @user : current_user, :bypass => true)
        format.html { redirect_to @user, notice: 'Your profile was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    # authorize! :update, @user 
    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to @user, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
      end
    end
  end

  # DELETE /users/:id.:format
  def destroy
    # authorize! :delete, @user
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_url }
      format.json { head :no_content }
    end
  end
  
    def self.for_persisted(provider)
      @user = User.find_for_oauth(request.env["omniauth.auth"], current_user)
      for_nonpersisted(provider) && !@user.persisted?
      set_flash_message(:notice, :success,
                        kind: provider.capitalize) && is_navigational_format?
      sign_in_and_redirect @user, event: :authentication
    end

    def self.for_nonpersisted(provider)
      session["devise.#{provider}_data"] = env['omniauth.auth']
      redirect_to new_user_registration_url
    end

    [:twitter, :facebook, :vkontakte, :instagram].each do |provider|
      for_persisted provider
    end

    def after_sign_in_path_for(resource)
      if resource.email_verified?
        super resource
      else
        finish_signup_path(resource)
      end
    end
    
  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      accessible = [ :name, :email ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
