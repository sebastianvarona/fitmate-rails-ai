class Message < ApplicationRecord
  belongs_to :chat

  validates :prompt, presence: true
  validates :answer, presence: true
end
