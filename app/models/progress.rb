class Progress < ApplicationRecord
  belongs_to :user

  validates :weight, :height, :chest, :arms, :waist, :hip, :thighs, :calves,
    numericality: {greater_than_or_equal_to: 0}, allow_nil: true
end
