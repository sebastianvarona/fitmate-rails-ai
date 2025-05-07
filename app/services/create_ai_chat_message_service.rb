# It creates a new Message related to the given Chat.
# In addition, it creates AiChat if it doesn't exist.
#
# e.g.
# To create a new chat:
# - CreateAiChatMessageService.call(prompt: 'Hi!', user_id: 1)
# To create a new message in an existing chat:
# - CreateAiChatMessageService.call(prompt: 'Define the term "AI"', ai_chat_id: 1)
# result:
# #<AiMessage:0x00000001272c6870
#   id: 1,
#   ai_chat_id: 1,
#   prompt: "Hello!",
#   answer: "How can I assist you today?",
#   created_at: "2024-12-06 18:34:36.198933000 +0000",
#   updated_at: "2024-12-06 18:34:36.198933000 +0000">

class CreateAiChatMessageService
  prepend SimpleCommand

  DEFAULT_MODEL_NAME = "llama3.2"

  def initialize(prompt:, ai_chat_id: nil, user_id: nil)
    @ai_chat_id = ai_chat_id
    @prompt = prompt
    @user_id = user_id
  end

  # It creates and returns a new Message related to the given/created Chat
  # @param prompt [String] the user's message to the AI
  # @param chat_id [Integer] [OPTIONAL] the chat id, if not provided it will create a new Chat
  # @param user_id [Integer] [OPTIONAL] the user id to create a new Chat, if the Chat is not provided
  # @return [Message] the created Message
  def call
    if !ai_chat_id && !user_id
      errors.add(:ai_chat_id, "or user_id is required")
    elsif ai_chat_id && !ai_chat
      errors.add(:ai_chat, "not found")
    elsif !ai_chat_id && !ai_chat
      errors.add(:ai_chat, "not created, check attributes")
    elsif ai_chat.errors.any?
      errors.add(:ai_chat, ai_chat.errors.full_messages.to_sentence)
    end

    errors.add(:prompt, "is required") if prompt.blank?


    if errors.any?
      # notify_error
      return
    end

    llm_response = llm.chat(messages:)

    ai_message = ai_chat.messages.create(prompt:, answer: llm_response.chat_completion)

    ai_message
  rescue StandardError
    # notify_error
  end

  private

  attr_reader :ai_chat_id, :prompt, :user_id

  # The LLM client.
  # @return [Langchain::LLM::Ollama] the LLM client
  def llm
    @llm ||= Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { temperature: 0.7, chat_model: "gpt-4o-mini" }
    )
  end

  # Find or create the AiChat on which add the AiMessage.
  def ai_chat
    @ai_chat ||=
      if ai_chat_id
        Chat.find_by(id: ai_chat_id)
      else
        # Generally AI Chat is created in the controller to provide the user with the chat url and just wait the response.
        Chat.create(user_id:, title: prompt.truncate(100))
      end
  end

  # Builds the message history for the current chat
  # @return [Array] the message history
  # @example
  #     [
  #       { role: 'user', content: 'Hi! My name is Purple.' },
  #       { role: 'assistant', content: 'Hi, Purple!' },
  #       { role: 'user', content: "What's my name?" }
  #     ]
  def messages
    return [] unless ai_chat

    @messages ||=
      begin
        ai_chat.messages.flat_map do |ai_message|
          [
            { role: "user", content: ai_message.prompt },
            { role: "assistant", content: ai_message.answer }
          ]
        end << { role: "user", content: prompt }
      end
    @messages.prepend({ role: "system", content: "Eres un entrenador personal experimentado, mantén un tono profesional pero motivador, como un entrenador deportivo. Las preguntas que te harán seran relacionadas al fitness y a la nutrición, responde acorde a esta temática." })
  end
end
