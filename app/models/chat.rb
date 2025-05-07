class Chat < ApplicationRecord
  belongs_to :user

  has_many :messages, -> { order(id: :asc) }, dependent: :delete_all
end
