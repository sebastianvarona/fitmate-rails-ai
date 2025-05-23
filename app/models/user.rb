class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  has_many :chats, -> { order(id: :desc) }, dependent: :delete_all
  has_many :routines, -> { order(id: :desc) }, dependent: :delete_all
  has_many :progresses, -> { order(id: :desc) }, dependent: :delete_all
end
