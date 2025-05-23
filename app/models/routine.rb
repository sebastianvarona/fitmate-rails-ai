class Routine < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :context, presence: true

  def selected_days
    JSON.parse weekdays
  end

  WEEKDAYS = %i[sunday monday tuesday wednesday thursday friday saturday]
end
