defmodule DiscordBot.Core.Consumer do
    use Coxir
    require DiscordBot.Utils.Logger

    defmodule State do
        defstruct [
            :server_name,
            :server_id,
            :server_icon,
            :owner,
            :joined_at,
            :region,
            message_history: []
        ]

        def init(message) do
            %State{
                server_name: message.name,
                server_id: message.id,
                server_icon: message.icon,
                owner: message.owner,
                joined_at: message.joined_at,
                region: message.region,
                message_history: []
            }
        end

        defmodule TempMessage do
            defstruct [
                :content,
                :sender,
                :channel,
                :timestamp,
                :id
            ]

            def init(message) do
                %TempMessage{
                    content: message.content,
                    sender: message.author,
                    channel: message.channel,
                    timestamp: message.timestamp,
                    id: message.id
                }
            end
        end

        def get_state(states, id) do
            Enum.find(states, nil, fn(elem) ->
                elem.server_id == id
            end)
        end

        def add_to_history(states, message) do
            {states2, state} = case get_state(states, message.id) do
                nil ->
                    {states, %State{
                        server_name: "private message",
                        server_id: "-1",
                        server_icon: "no_icon",
                        owner: "discord",
                        message_history: []
                    }}
                elem ->
                    {Enum.filter(states, fn x -> x != elem end), elem}
            end
            newHist = [ TempMessage.init(message) | state.message_history]
            [%State{state | message_history: newHist} | states2]
        end

        def get_history(state) do
            inspect(state.message_history, pretty: true)
        end
    end

    ## Ran on Join
        def handle_event({type = :READY, message}, state) do
            DiscordBot.Utils.Logger.metadata(type, message)
            DiscordBot.Utils.Logger.info("#{inspect(Map.keys(message), [pretty: true])}")
            {:ok, state}
        end

        def handle_event({type = :GUILD_CREATE, message}, state) do
            state2 = add_server_to_state(state, message)
            DiscordBot.Utils.Logger.metadata(type, message)
            DiscordBot.Utils.Logger.info("#{inspect(Map.keys(message), [pretty: true])}")
            {:ok, state2}
        end
    ##

    ## On Message x
        def handle_event({type = :TYPING_START, message}, state) do
            DiscordBot.Utils.Logger.metadata(type, message, [username: DiscordBot.Utils.get_username(message, :member)])
            DiscordBot.Utils.Logger.info("#{inspect(Map.keys(message), [pretty: true])}")
            {:ok, state}
        end

        def handle_event({type = :MESSAGE_CREATE, message}, states) do
            DiscordBot.Utils.Logger.metadata(type, message, [username: DiscordBot.Utils.get_username(message, :author)])
            DiscordBot.Utils.Logger.info("#{inspect(message.content)}")
            DiscordBot.Utils.Logger.info("#{inspect(Map.keys(message), [pretty: true])}")

            states2 = (
                State.get_state(states, message.id)
                |> DiscordBot.Core.Commands.Handler.try_command(message.content, [message])
                |> State.add_to_history(message)
            )

            {:ok, states2}
        end
    ##

    def handle_event({type, _message}, state) do
        DiscordBot.Utils.Logger.info("{#{inspect type}}")
        {:ok, state}
    end

    def add_server_to_state(state, message) do
        server_data = State.init(message)
        [ server_data | state ]
    end
end
