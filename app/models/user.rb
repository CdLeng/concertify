class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :email, uniqueness: true

  has_many :saved_concerts, dependent: :destroy
  has_many :followed_artists, dependent: :destroy
  validates :name, uniqueness: true
end
