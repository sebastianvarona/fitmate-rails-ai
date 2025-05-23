require "test_helper"

class ChatTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
  end

  test "should be valid with user and title" do
    chat = Chat.new(user: @user, title: "Nuevo chat")
    assert chat.valid?
  end

  test "should be invalid without user" do
    chat = Chat.new(title: "Nuevo chat")
    assert_not chat.valid?
    assert_includes chat.errors[:user], "must exist"
  end

  test "title can be blank" do
    chat = Chat.new(user: @user)
    assert chat.valid?
  end

  test "should respond to user and messages" do
    chat = chats(:one)
    assert_respond_to chat, :user
    assert_respond_to chat, :messages
  end
end
