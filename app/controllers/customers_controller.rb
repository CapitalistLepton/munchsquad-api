class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  def index
    @customers = Customer.all
    json_response(@customers)
  end

  def create
    if Customer.where("username = ?", customer_params[:username]).blank?
      @customer = Customer.create!(customer_params)
      json_response(@customer, :created)
    else 
      json_response({ message: "Username is already taken" },  :unprocessable_entity)
    end
  end

  def show
    json_response(@customer)
  end

  def update
    @customer.update(customer_params)
    head :no_content
  end

  def destroy
    @customer.destroy
    head :no_content
  end

  private

  def customer_params
    # whitelist params
    params.permit(:username, :name, :password)
    pass = ActionController::Parameters.new({
      password: BCrypt::Password.create(params[:password]).to_s
    }).permit(:password)
    cust = params.permit(:name, :username)
    cust.merge!(pass)
  end

  def set_customer
    @customer = Customer.find_by_username(params[:id])
  end
end
