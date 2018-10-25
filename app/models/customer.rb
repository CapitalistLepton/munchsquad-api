class Customer < ApplicationRecord

  def to_param
    username
  end

  validates_presence_of :username, :name, :password
end
