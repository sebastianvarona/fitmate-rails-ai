class Routine < ApplicationRecord
  belongs_to :user

  validates :title,
    presence: {message: "no puede estar vacío"},
    length: {
      minimum: 3,
      maximum: 100,
      too_short: "es demasiado corto (mínimo %{count} caracteres)",
      too_long: "es demasiado largo (máximo %{count} caracteres)"
    }

  validates :context,
    presence: {message: "no puede estar vacío"},
    length: {
      minimum: 10,
      maximum: 1000,
      too_short: "es demasiado corto (mínimo %{count} caracteres)",
      too_long: "es demasiado largo (máximo %{count} caracteres)"
    }

  def selected_days
    JSON.parse(weekdays || "[]").map(&:to_s)
  end

  WEEKDAYS = %i[sunday monday tuesday wednesday thursday friday saturday]
end
