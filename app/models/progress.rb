class Progress < ApplicationRecord
  belongs_to :user

  validates :user_id,
    presence: {message: "debe estar presente"}

  validates :weight,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 0,
      less_than_or_equal_to: 500,
      message: "debe ser un número entre 0 y 500 kg"
    }

  validates :chest,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 30,
      less_than_or_equal_to: 200,
      message: "debe estar entre 30 y 200 cm"
    }

  validates :arms,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 10,
      less_than_or_equal_to: 70,
      message: "debe estar entre 10 y 70 cm"
    }

  validates :waist,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 30,
      less_than_or_equal_to: 200,
      message: "debe estar entre 30 y 200 cm"
    }

  validates :hip,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 30,
      less_than_or_equal_to: 200,
      message: "debe estar entre 30 y 200 cm"
    }

  validates :thighs,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 20,
      less_than_or_equal_to: 120,
      message: "debe estar entre 20 y 120 cm"
    }

  validates :calves,
    presence: {message: "no puede estar vacío"},
    numericality: {
      greater_than_or_equal_to: 20,
      less_than_or_equal_to: 80,
      message: "debe estar entre 20 y 80 cm"
    }
end
