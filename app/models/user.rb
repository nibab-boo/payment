class User < ApplicationRecord
  pay_customer
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :subscriptions, dependent: :destroy
  def subscribed?
    subscripted != "free"
  end
end
