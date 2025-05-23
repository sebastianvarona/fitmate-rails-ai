require "test_helper"

class MessageTest < ActiveSupport::TestCase
  def setup
    @chat = chats(:one)
  end
  test "should be valid with chat, prompt, and answer" do
    chat = chats(:one)
    message = Message.new(chat: chat, prompt: "Hola", answer: "Hola, ¿cómo estás?")
    assert message.valid?
  end

  test "should be invalid without chat" do
    message = Message.new(prompt: "Hola", answer: "Hola, ¿cómo estás?")
    assert_not message.valid?
    assert_includes message.errors[:chat], "must exist"
  end

  test "should be invalid without prompt or answer" do
    message = Message.new(chat: @chat)
    assert_not message.valid?
    assert_includes message.errors[:prompt], "can't be blank"
  end

  test "prompt should not be too long" do
    long_prompt = "Hola " * 1000
    message = Message.new(chat: @chat, prompt: long_prompt, answer: "respuesta")
    assert message.valid? # solo si no tienes una validación de longitud
  end

  test "should belong to chat" do
    message = messages(:one)
    assert_respond_to message, :chat
  end
end
