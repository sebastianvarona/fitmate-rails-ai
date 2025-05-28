require "test_helper"

class ProgressesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @user = users(:one)
    @other_user = users(:two)
    @progress = progresses(:one) # belongs to @user
    @other_progress = progresses(:two)
    sign_in @user
  end

  test "should get index" do
    get progresses_url
    assert_response :success
    assert_select "h1", /Mi Progreso/i
  end

  test "should get new" do
    get new_progress_url
    assert_response :success
  end

  test "should create progress" do
    assert_difference("Progress.count") do
      post progresses_url, params: {
        progress: {
          weight: 70,
          height: 170,
          chest: 90,
          arms: 30,
          waist: 75,
          hip: 95,
          thighs: 55,
          calves: 35
        }
      }
    end

    assert_redirected_to progresses_path
  end

  test "should not create invalid progress" do
    assert_no_difference("Progress.count") do
      post progresses_url, params: {
        progress: {
          weight: -1, # invalid
          height: nil
        }
      }
    end

    assert_response :unprocessable_entity
  end

  test "should show progress" do
    get progress_url(@progress)
    assert_response :success
  end

  test "should get edit" do
    get edit_progress_url(@progress)
    assert_response :success
  end

  test "should update progress" do
    patch progress_url(@progress), params: {
      progress: {weight: 80}
    }

    assert_redirected_to progress_url(@progress)
    @progress.reload
    assert_equal 80, @progress.weight
  end

  test "should not update invalid progress" do
    patch progress_url(@progress), params: {
      progress: {weight: -10}
    }

    assert_response :unprocessable_entity
    @progress.reload
    refute_equal(-10, @progress.weight)
  end

  test "should destroy progress" do
    assert_difference("Progress.count", -1) do
      delete progress_url(@progress)
    end

    assert_redirected_to progresses_path
  end

  test "should not allow access to other user's progress" do
    get progress_path(@other_progress)
    assert_response :not_found
  end
end
