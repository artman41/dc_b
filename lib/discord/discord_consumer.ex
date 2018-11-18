defmodule Discord.DiscordConsumer do
    use Coxir
    require Discord.DiscordLogger

    ## Ran on Join
        def handle_event({type = :READY, message}, state) do
            Discord.DiscordLogger.metadata(type, message)
            Discord.DiscordLogger.info("#{inspect(Map.keys(message), [pretty: true])}")
            {:ok, state}
        end

        def handle_event({type = :GUILD_CREATE, message}, state) do
            Discord.DiscordLogger.metadata(type, message)
            Discord.DiscordLogger.info("#{inspect(Map.keys(message), [pretty: true])}")
            {:ok, state}
        end
    ##

    ## On Message x
        def handle_event({type = :TYPING_START, message}, state) do
            Discord.DiscordLogger.metadata(type, message, [username: inspect(message.member.user.username)])
            Discord.DiscordLogger.info("#{inspect(Map.keys(message), [pretty: true])}")
            {:ok, state}
        end

        def handle_event({type = :MESSAGE_CREATE, message}, state) do
            Discord.DiscordLogger.metadata(type, message, [username: inspect(message.author.username)])
            Discord.DiscordLogger.info("#{inspect(message.content)}")
            Discord.DiscordLogger.info("#{inspect(Map.keys(message), [pretty: true])}")
            case message.content do
                "ping!" ->
                    Message.reply(message, "pong!")
                _ ->
                    :ignore
            end

            {:ok, state}
        end
    ##

    def handle_event({type, _message}, state) do
        Discord.DiscordLogger.info("{#{inspect type}}")
        {:ok, state}
    end
end
