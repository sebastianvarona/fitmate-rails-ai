require "test_helper"

class RoutineTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid with required attributes" do
    routine = Routine.new(title: "Rutina", context: "Ejercicio con más de 10 caracteres", content: "Pushups", weekdays: ["monday"], user: @user)
    assert routine.valid?
  end

  test "should be invalid without user" do
    routine = Routine.new(title: "Rutina", context: "Ejercicio", content: "Pushups")
    assert_not routine.valid?
    assert_includes routine.errors[:user], "must exist"
  end

  test "should be invalid without title" do
    routine = Routine.new(context: "Contexto", user: @user)
    assert_not routine.valid?
    assert_includes routine.errors[:title], "no puede estar vacío"
  end

  test "weekdays should be an array" do
    routine = Routine.new(title: "Test", context: "Contexto", weekdays: ["monday", "friday"], user: @user)
    assert_kind_of Array, routine.weekdays
  end

  test "should respond to user" do
    routine = routines(:one)
    assert_respond_to routine, :user
  end
end
