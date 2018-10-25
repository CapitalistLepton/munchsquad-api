class CustomersController < ApplicationController
  before_action :set_customer, only: [:show, :update, :destroy]

  # GET /todos
  def index
    @customers = Customer.all
    json_response(@customers)
  end

  # POST /todos
  def create
    puts customer_params[:password]
    pass = ActionController::Parameters.new({
      password: BCrypt::Password.create(customer_params[:password]).to_s
    }).permit(:password)
    puts pass
    cust = customer_params.permit(:name, :username)
    cust.merge!(pass)
    puts cust 
    @customer = Customer.create!(cust)
    json_response(@customer, :created)
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
  end

  def set_customer
    @customer = Customer.find_by_username(params[:id])
  end
end
