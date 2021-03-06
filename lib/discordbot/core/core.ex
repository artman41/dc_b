defmodule DiscordBot.Core do
    use Application
    use Supervisor
    require Logger

    def start(_type, _args) do
        Logger.info("starting")
        children = [
            worker(DiscordBot.Core.Consumer, [])
        ]
        options = [
            strategy: :one_for_one,
            name: __MODULE__
        ]
        Supervisor.start_link(children, options)
    end

    def stop(state) do
        inspect(state)
    end
end
