module RoutinesHelper
  def weekday
    wday = Time.now.wday

    case wday
    when 0
      "Domingo"
    when 1
      "Lunes"
    when 2
      "Martes"
    when 3
      "Miércoles"
    when 4
      "Jueves"
    when 5
      "Viernes"
    when 6
      "Sábado"
    else
      "Desconocido"
    end
  end

  def weekday_to_s(wday)
    case wday
    when :sunday
      "Domingo"
    when :monday
      "Lunes"
    when :tuesday
      "Martes"
    when :wednesday
      "Miércoles"
    when :thursday
      "Jueves"
    when :friday
      "Viernes"
    when :saturday
      "Sábado"
    else
      "Desconocido"
    end
  end
end
