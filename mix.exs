defmodule Discord.MixProject do
    use Mix.Project

    def project do
        [
            app: :discord,
            version: "0.1.0",
            elixir: "~> 1.7",
            build_embedded: Mix.env == :prod,
            start_permanent: Mix.env() == :prod,
            deps: deps()
        ]
    end

    # Run "mix help compile.app" to learn about applications.
    def application do
        [
            mod: {Discord, [
                    :logger
                ]
            }
        ]
    end

    # Run "mix help deps" to learn about dependencies.
    defp deps do
        [
            # {:dep_from_hexpm, "~> 0.3.0"},
            # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
            {:coxir, git: "https://github.com/satom99/coxir.git"}
        ]
    end
end
