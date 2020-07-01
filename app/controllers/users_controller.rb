class UsersController < ApplicationController
  skip_before_action :authorize
  #FIXME_AB: remove destroy action
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  #FIXME_AB: remove index
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    #FIXME_AB: User.user.new
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        #FIXME_AB: lets start uisng I18n
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def verify
    #FIXME_AB: find by token User.unverified.find....
    user = User.find(params[:id])
    #FIXME_AB: if user && user.activate! ==> will return true or false after checking the validatity of token
    if user
      if user.verifcation_at.nil?
        redirect_to root_path, notice: "Account verified." if user.activate_account(params[:token])
      else
        redirect_to root_path, notice: "Account already verified."
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
      #FIXME_AB: what if user with id not found
    end

    # Only allow a list of trusted parameters through.
    def user_params
      #FIXME_AB: why allowed role. I can set my self admin. remove role
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :role)
    end

end
