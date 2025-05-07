# To create a new routine:
# - CreateAiRoutineService.call(title: 'Hi!', context: 'Context for the routine', user_id: 1)
# To update an existing routine:
# - CreateAiChatMessageService.call(context: 'Define the term "AI"', routine_id: 1)
# result:
# #<Routine:0x00000001272c6870
#   id: 1,
#   user_id: 1,
#   title: "Hello!",
#   context: "Give me an arms routine at home",
#   content: "How can I assist you today?",
#   created_at: "2024-12-06 18:34:36.198933000 +0000",
#   updated_at: "2024-12-06 18:34:36.198933000 +0000">

class CreateAiRoutineService
  prepend SimpleCommand

  DEFAULT_MODEL_NAME = "llama3.2"

  def initialize(context:, title: nil, user_id: nil, routine_id: nil)
    @context = context
    @title = title
    @user_id = user_id
    @routine_id = routine_id
  end

  # It creates and returns a new Routine related to the given/created Routine
  # @param context [String] the user's message to the AI
  # @param title [String] [OPTIONAL] the title for the Routine
  # @param routine_id [Integer] [OPTIONAL] the routine id, if not provided it will create a new Routine
  # @param user_id [Integer] [OPTIONAL] the user id to create a new Routine, if the Routine is not provided
  # @return [Routine] the created Routine
  def call
    if !routine_id && !user_id
      errors.add(:routine_id, "or user_id is required")
    elsif routine_id && !ai_routine
      errors.add(:ai_routine, "not found")
    elsif !routine_id && !ai_routine
      errors.add(:ai_routine, "not created, check attributes")
    elsif ai_routine.errors.any?
      errors.add(:ai_routine, ai_routine.errors.full_messages.to_sentence)
    end

    errors.add(:context, "is required") if context.blank?


    if errors.any?
      # notify_error
      return
    end

    llm_response = llm.chat(messages:)

    routine = ai_routine
    routine.update(content: llm_response.chat_completion)

    routine
  rescue StandardError
    # notify_error
  end

  private

  attr_reader :routine_id, :context, :title, :user_id

  # The LLM client.
  # @return [Langchain::LLM::Ollama] the LLM client
  def llm
    @llm ||= Langchain::LLM::OpenAI.new(
      api_key: ENV["OPENAI_API_KEY"],
      default_options: { temperature: 0.7, chat_model: "gpt-4o-mini" }
    )
  end

  # Find or create the Routine on which add the new context.
  def ai_routine
    @ai_routine ||=
      if routine_id
        Routine.find_by(id: routine_id)
      else
        # Generally AI Routine is created in the controller to provide the user with the routine url and just wait the response.
        Routine.create(user_id:, title:, context:)
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
    return [] unless ai_routine

    @messages ||=
      begin
        routine = ai_routine
        system_prompt = <<-TEXT
          Eres un entrenador personal experimentado que debe seguir estas instrucciones exactamente:

          1. Mantén un tono profesional pero motivador, como un entrenador deportivo
          2. Responde únicamente con la rutina de ejercicios, sin saludos ni despedidas
          3. Utiliza el siguiente formato markdown obligatoriamente:
            - Encabezados H3 para secciones principales (Calentamiento, Rutina Principal, etc.)
            - Listas ordenadas para secuencias de ejercicios
            - Listas no ordenadas para detalles específicos de cada ejercicio
            - Bloques de código markdown para tiempos y repeticiones
            - Enlaces markdown para recursos adicionales cuando sea necesario

          4. Para cada ejercicio, incluye:
            - Nombre del ejercicio
            - Descripción técnica
            - Series y repeticiones
            - Tiempo de descanso
            - Notas importantes sobre forma correcta

          5. La respuesta debe comenzar inmediatamente después de esta instrucción y terminar con la última línea de la rutina.
          6. No incluyas titulo de la rutina.

          Tu objetivo es generar una rutina que sea fácil de seguir y comprender, manteniendo un tono motivador pero profesional.
        TEXT


        if routine.content
          [
            { role: "system", content: system_prompt },
            { role: "user", content: routine.context  },
            { role: "assistant", content: routine.content },
            { role: "user", content: context }
          ]
        else
          [
            { role: "system", content: system_prompt },
            { role: "user", content: context }
          ]
        end


      end
  end
end
