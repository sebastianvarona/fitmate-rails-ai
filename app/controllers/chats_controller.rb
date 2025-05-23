class ChatsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_chat, only: %i[show destroy]

  def index
    @chats = Chat.all.where(user: current_user).order(id: :desc)
  end

  def show
  end

  def create
    response = CreateAiChatMessageService.call(
      prompt: params[:prompt],
      user_id: current_user.id
    )
    @chat = response.result.chat
    redirect_to @chat
  end

  def destroy
    @chat.destroy!

    redirect_to chats_path
  end

  def create_message
    response = CreateAiChatMessageService.call(
      prompt: params[:prompt],
      ai_chat_id: params[:id]
    )

    if response.success?
      render json: {
        success: true,
        question: response.result.prompt,
        answer: response.result.answer
      }
    else
      render json: {success: false, error: response.errors.full_messages.join(", ")},
        status: :unprocessable_entity
    end
  rescue => e
    render json: {success: false, error: e.message},
      status: :internal_server_error
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  end
end
