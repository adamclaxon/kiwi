defmodule Kiwi.MixProject do
    use Mix.Project

    @all_targets [:rpi, :rpi0, :rpi2, :rpi3, :rpi3a, :bbb, :x86_64]

    def project do
        [
            app: :kiwi,
            version: "0.1.0",
            elixir: "~> 1.8",
            archives: [nerves_bootstrap: "~> 1.5"],
            start_permanent: Mix.env() == :prod,
            build_embedded: true,
            aliases: [loadconfig: [&bootstrap/1]],
            deps: deps()
        ]
    end

    def bootstrap(args) do
        Application.start(:nerves_bootstrap)
        Mix.Task.run("loadconfig", args)
    end

    def application do
        [
            mod: {Kiwi.Application, []},
            extra_applications: [:logger, :runtime_tools, :mnesia],
            # included_applications: [:mnesia]
        ]
    end

    defp deps do
        [
            # Dependencies for all targets
            {:nerves, "~> 1.4", runtime: false},
            {:shoehorn, "~> 0.4"},
            {:ring_logger, "~> 0.6"},
            {:toolshed, "~> 0.2"},
            {:circuits_gpio, "~> 0.4.1"},
            {:circuits_spi, "~> 0.1.3"},
            {:circuits_i2c, "~> 0.3.3"},
            {:maru, "~> 0.14.0-pre.1"},
            {:plug_cowboy, "~> 2.0"},
            {:jason, "~> 1.1"},
            {:corsica, "~> 1.1"},
            {:mojito, "~> 0.2.0"},
            {:nerves_time, "~> 0.2.1", targets: @all_targets},

            # Dependencies for all targets except :host
            {:nerves_runtime, "~> 0.6", targets: @all_targets},
            {:nerves_init_gadget, "~> 0.4", targets: @all_targets},

            # Dependencies for specific targets
            {:nerves_system_rpi, "~> 1.6", runtime: false, targets: :rpi},
            {:nerves_system_rpi0, "~> 1.6", runtime: false, targets: :rpi0},
            {:nerves_system_rpi2, "~> 1.6", runtime: false, targets: :rpi2},
            {:nerves_system_rpi3, "~> 1.6", runtime: false, targets: :rpi3},
            {:nerves_system_rpi3a, "~> 1.6", runtime: false, targets: :rpi3a},
            {:nerves_system_bbb, "~> 2.0", runtime: false, targets: :bbb},
            {:nerves_system_x86_64, "~> 1.6", runtime: false, targets: :x86_64},
        ]
    end
end
