defmodule DiscordBot.Utils.Logger do
    require Logger

    def metadata(type, message, extra_data \\ []) do
        keys = Enum.map(Map.keys(message), fn(key) ->
            {key, message[key]}
        end)
        [{:event_type, type} | keys]
        |> Enum.concat(extra_data)
        |> Logger.metadata()
    end

    def info(message) do
        Logger.info(message)
    end
end
