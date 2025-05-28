require "test_helper"
require "json"

class RoutinesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @user = users(:one)
    sign_in @user

    # Crear algunas rutinas de prueba
    @routine = @user.routines.create!(
      title: "Entrenamiento matutino",
      context: "Ejercicios básicos de cardio y fuerza",
      weekdays: JSON.generate(["monday"])
    )

    @invalid_routine = {
      title: "",
      context: "Corto",
      weekdays: JSON.generate([])
    }
  end

  # Pruebas para autenticación
  test "redirige a login cuando no hay usuario autenticado" do
    sign_out @user

    get routines_path
    assert_redirected_to new_user_session_path

    post routines_path, params: {routine: @invalid_routine}
    assert_redirected_to new_user_session_path
  end

  # Pruebas para index
  test "index muestra las rutinas del usuario" do
    get routines_path

    assert_response :success
    assert_template :index
  end

  # Pruebas para create
  test "crea una nueva rutina exitosamente" do
    return
    assert_difference "@user.routines.count" do
      post routines_path, params: {
        routine: {
          title: "Entrenamiento nocturno",
          context: "Estiramientos y yoga",
          weekdays: JSON.generate([:tuesday])
        }
      }
    end

    assert_redirected_to routine_path(assigns(:routine))
    assert flash[:notice].present?
  end

  test "no crea una rutina inválida" do
    assert_no_difference "@user.routines.count" do
      post routines_path, params: {routine: @invalid_routine}
    end

    assert_response :unprocessable_entity
    assert_template :new
  end

  # Pruebas para destroy
  test "elimina una rutina exitosamente" do
    assert_difference "@user.routines.count", -1 do
      delete routine_path(@routine)
    end

    assert_redirected_to routines_path
    assert flash[:alert].present?
  end

  # Pruebas para set_wday
  test "elimina un día de la semana exitosamente" do
    original_weekdays = @routine.selected_days

    post set_wday_routine_path(@routine), params: {
      day: :monday,
      checked: 0
    }

    @routine.reload
    refute_includes @routine.selected_days, :monday
    refute_equal original_weekdays.sort, @routine.selected_days.sort
    assert_redirected_to @routine
  end

  # Prueba para manejo de errores
  test "maneja el error cuando la rutina no existe" do
    get routine_path(id: "invalid")
    assert_response :not_found
  end
end
