defmodule DiscordBot.Core.Commands.Handler do
    alias DiscordBot.Core.Commands.Engine

    def try_command(state, bin_string, args) do
        Engine.parse_command(bin_string)
        |> Engine.execute(state, args)
        state
    end

end
