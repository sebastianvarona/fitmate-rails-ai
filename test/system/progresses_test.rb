require "application_system_test_case"

class ProgressesTest < ApplicationSystemTestCase
  setup do
    @progress = progresses(:one)
  end

  test "visiting the index" do
    visit progresses_url
    assert_selector "h1", text: "Progresses"
  end

  test "should create progress" do
    visit progresses_url
    click_on "New progress"

    fill_in "Arms", with: @progress.arms
    fill_in "Calves", with: @progress.calves
    fill_in "Chest", with: @progress.chest
    fill_in "Height", with: @progress.height
    fill_in "Hip", with: @progress.hip
    fill_in "Thighs", with: @progress.thighs
    fill_in "User", with: @progress.user_id
    fill_in "Waist", with: @progress.waist
    fill_in "Weight", with: @progress.weight
    click_on "Create Progress"

    assert_text "Progress was successfully created"
    click_on "Back"
  end

  test "should update Progress" do
    visit progress_url(@progress)
    click_on "Edit this progress", match: :first

    fill_in "Arms", with: @progress.arms
    fill_in "Calves", with: @progress.calves
    fill_in "Chest", with: @progress.chest
    fill_in "Height", with: @progress.height
    fill_in "Hip", with: @progress.hip
    fill_in "Thighs", with: @progress.thighs
    fill_in "User", with: @progress.user_id
    fill_in "Waist", with: @progress.waist
    fill_in "Weight", with: @progress.weight
    click_on "Update Progress"

    assert_text "Progress was successfully updated"
    click_on "Back"
  end

  test "should destroy Progress" do
    visit progress_url(@progress)
    accept_confirm { click_on "Destroy this progress", match: :first }

    assert_text "Progress was successfully destroyed"
  end
end
