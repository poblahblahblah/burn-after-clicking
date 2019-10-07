require 'bcrypt'

class SecretsController < ApplicationController
  before_action :set_secret, only: [:show, :update, :destroy]
  before_action :set_expiration, only: [:create]

  # GET /secrets
  # GET /secrets.json
  def index
    @secrets = Secret.all
  end

  # GET /secrets/1
  # GET /secrets/1.json
  def show
  end

  # GET /secrets/new
  def new
    @secret = Secret.new
  end

  # This is how we unlock the secret
  def update
    if verify_password
      @body = decrypt_body
      respond_to do |format|
        format.html { render :unlocked, status: :ok, location: @secret, notice: 'Secret has been unlocked and destroyed' }
        format.json { render :unlocked, status: :ok, location: @secret }

        # Destroy after rendering
        Thread.new { @secret.destroy }
      end
    else
      @secret.errors.add(:incorrect_password, " - The password you entered was incorrect. Please try again.")
      respond_to do |format|
        format.html { render :show, status: 401 }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /secrets
  # POST /secrets.json
  def create
    @secret = Secret.new(secret_params)

    respond_to do |format|
      if @secret.save
        format.html { render :preview, status: :ok, location: @secret, notice: 'Secret was successfully created.' }
        format.json { render :preview, status: :ok, location: @secret }
      else
        format.html { render :new }
        format.json { render json: @secret.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /secrets/1
  # DELETE /secrets/1.json
  def destroy
    @secret.destroy
    respond_to do |format|
      format.html { redirect_to secrets_url, notice: 'Secret was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_secret
      @secret = Secret.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def secret_params
      params.require(:secret).permit(:body, :password, :expiration, :unlock_password)
    end

    def set_expiration
      expiry = params[:secret][:expiration].empty? ? 1 : params[:secret][:expiration].to_i
      params[:secret][:expiration] = Time.current + (expiry * 60 * 60 )
    end

    def verify_password
      if @secret[:password].empty?
        return true
      else
        if BCrypt::Password.new(@secret[:password]) == params[:secret][:unlock_password]
          return true
        else
          return false
        end
      end
    end

    def decrypt_body
      pass  = params.key?(:no_password) ? ENV['SECRET_BODY_CRYPT_KEY'] : params[:secret][:unlock_password]
      key   = ActiveSupport::KeyGenerator.new(pass).generate_key(@secret.encrypted_body_salt, 32)
      crypt = ActiveSupport::MessageEncryptor.new(key)

      return crypt.decrypt_and_verify(@secret.encrypted_body)
    end

end
