class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :photo

  validates :email, uniqueness: true, presence: true
  validates :name, uniqueness: true, presence: true
  validates :country_code, presence: true
  validates :city, presence: true

  has_many :saved_concerts, dependent: :destroy
  has_many :followed_artists, dependent: :destroy
end
