defmodule Discord.DiscordConsumer do
    use Coxir

    def handle_event({type = :MESSAGE_CREATE, message}, state) do
        IO.puts("{#{inspect type}} #{inspect message.content}")
        case message.content do
            "ping!" ->
                Message.reply(message, "pong!")
            _ ->
                :ignore
        end

        {:ok, state}
    end

    def handle_event({type, _message}, state) do
        IO.puts("{#{inspect type}}")
        {:ok, state}
    end
end
