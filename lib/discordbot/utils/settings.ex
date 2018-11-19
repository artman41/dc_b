defmodule DiscordBot.Utils.Settings do

    def get_app() do
        Application.get_application(__MODULE__)
    end

    def get_config(mod, key) do
        Application.get_env(get_app(), mod, [])
        |> Keyword.get(key)
    end

    def set_config(mod, key, value) do
        app = get_app()
        newConfig = (
            Application.get_env(app, mod, [])
            |> Keyword.put(key, value)
        )
        Application.put_env(app, mod, newConfig)
    end

end
