class RoutinesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_routine, only: %i[show set_wday destroy]

  def index
    @routine = Routine.new
    @routines = Routine.all.where(user: current_user).order(id: :desc)

    @today = []
    @other = []

    @routines.each do |routine|
      if routine.selected_days.include?(symbol_weekday.to_s)
        @today.push(routine)
      else
        @other.push(routine)
      end
    end
  end

  def new
    @routine = Routine.new
  end

  def create
    response = CreateAiRoutineService.call(
      context: params[:routine][:context],
      title: params[:routine][:title],
      user_id: current_user.id
    )
    @routine = response.result
    redirect_to @routine, notice: "Rutina creada exitosamente."
  end

  def destroy
    @routine.destroy!

    redirect_to routines_path, alert: "La rutina ha sido eliminada."
  end

  def set_wday
    routine_weekdays = JSON.parse(@routine.weekdays)

    if params[:checked] == 1
      routine_weekdays.push(params[:day]) unless routine_weekdays.include?(params[:day])
    else
      routine_weekdays.delete(params[:day])
    end

    @routine.update(weekdays: routine_weekdays.to_json)

    redirect_to @routine
  end

  private

  def set_routine
    @routine = Routine.find(params[:id])
  end

  def symbol_weekday
    wday = Time.now.wday

    case wday
    when 0
      :sunday
    when 1
      :monday
    when 2
      :tuesday
    when 3
      :wednesday
    when 4
      :thursday
    when 5
      :friday
    when 6
      :saturday
    else
      :unknown
    end
  end
end
