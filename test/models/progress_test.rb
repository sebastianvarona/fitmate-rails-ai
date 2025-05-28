require "test_helper"

class ProgressTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid with user and measurements" do
    progress = Progress.new(user: @user, weight: 70, height: 175, chest: 90, arms: 30, waist: 80, hip: 95, thighs: 60, calves: 35)
    assert progress.valid?
  end

  test "should be invalid without user" do
    progress = Progress.new(weight: 70)
    assert_not progress.valid?
    assert_includes progress.errors[:user], "must exist"
  end

  test "should not accept negative values" do
    progress = Progress.new(user: @user, weight: -5, height: -180)
    assert_not progress.valid?
  end

  test "should not accept decimal values" do
    progress = Progress.new(user: @user, weight: 75.5, height: 180.2)
    assert_not progress.valid?
  end

  test "should belong to user" do
    progress = progresses(:one)
    assert_respond_to progress, :user
  end
end
