class ProgressesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_progress, only: %i[show edit update destroy]

  rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found

  def index
    @progresses = current_user.progresses.all
    @chart = []
    @chart << @progresses.last if @progresses.any?
    @chart << @progresses.first if @progresses.any?
  end

  def show
  end

  def new
    @progress = Progress.new
  end

  def edit
  end

  def create
    @progress = current_user.progresses.new(progress_params)

    respond_to do |format|
      if @progress.save
        format.html { redirect_to progresses_path, notice: "Progreso actualizado exitosamente." }
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @progress.update(progress_params)
        format.html { redirect_to @progress, notice: "Progreso actualizado exitosamente." }
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @progress.destroy!

    respond_to do |format|
      format.html { redirect_to progresses_path, status: :see_other, notice: "Progreso eliminado exitosamente." }
    end
  end

  private

  def set_progress
    @progress = current_user.progresses.find(params[:id])
  end

  def progress_params
    params.require(:progress).permit(:weight, :height, :chest, :arms, :waist, :hip, :thighs, :calves, :user_id)
  end
end
