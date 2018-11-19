defmodule DiscordBot.Utils do

    def get_username(message, type \\ :member) do
        case type do
            :member ->
                member = Map.get(message, :member)
                case member do
                    nil ->
                        nil
                    _ ->
                        member
                        |> Map.get(:user)
                        |> Map.get(:username)
                end
                |> inspect()
            :author ->
                inspect(message.author.username)
                author = Map.get(message, :author)
                case author do
                    nil ->
                        nil
                    _ ->
                        author
                        |> Map.get(:username)
                end
                |> inspect()
            _ ->
                nil
        end
    end

end
