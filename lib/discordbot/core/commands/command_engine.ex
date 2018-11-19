defmodule DiscordBot.Core.Commands.Engine do
    use Coxir

    defmodule Command do
        defstruct [
            name: "command",
            desc: "description",
            args: [:message],
            fun: &Command.default_fun/2
        ]

        def default_fun(state, _args), do: state

        def get_args(com), do: com.args
        def execute(com, state, args), do: com.fun.(state, args)

        defmodule Starter do
            defstruct [
                :name,
                :args
            ]
            def create(com) do
                prefix = DiscordBot.Utils.Settings.get_config(__MODULE__, :command_prefix)
                <<_com_prefix :: size(prefix), command_text :: binary>> = com
                [name, args] = String.split(command_text)
                %Starter{
                    name: String.downcase(name),
                    args: args
                }
            end
        end
    end

    defp commands() do
        [
            %Command{
                name: "ping",
                desc: "Command to test the bot!",
                fun: fn(state, args) ->
                        Message.reply(args[:message], "pong!")
                        state
                    end
            },
            %Command{
                name: "state",
                desc: "Returns the current state.",
                fun: fn(state, args) ->
                        Message.reply(args[:message], inspect(state, pretty: true))
                        state
                    end
            },
            %Command{
                name: "message_history",
                desc: "Returns the current message history.",
                fun: fn(state, args) ->
                        Message.reply(args[:message], DiscordBot.Core.Consumer.State.get_history(state))
                        state
                    end
            }
        ]
    end

    def check_prefix(com) do
        prefix = DiscordBot.Utils.Settings.get_config(__MODULE__, :command_prefix)
        <<com_prefix :: size(prefix), _c :: binary>> = com
        prefix == com_prefix
    end

    def parse_command(com) do
        if check_prefix(com) do
            tmpCom = Command.Starter.create(com)
            Enum.find(commands(), Command.default(), fn(elem) ->
                String.downcase(elem.name) == tmpCom.name
            end)
        else
            Command.default()
        end
    end

end
