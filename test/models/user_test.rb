require "test_helper"

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(email: "user@example.com", password: "password")
  end

  test "should be valid with email and password" do
    assert @user.valid?
  end

  test "should be invalid without email" do
    user = User.new(password: "password")
    assert_not user.valid?
    assert_includes user.errors[:email], "can't be blank"
  end

  test "should be invalid without password" do
    user = User.new(email: "user@example.com")
    assert_not user.valid?
  end

  test "email must be unique" do
    @user.save!
    duplicate = User.new(email: "user@example.com", password: "password123")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:email], "has already been taken"
  end

  test "should have many routines" do
    assert_respond_to @user, :routines
  end

  test "should have many progresses" do
    assert_respond_to @user, :progresses
  end
end
