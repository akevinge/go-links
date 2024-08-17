# Go Link Server (Elixir Implementation)

## Run

1.  Ensure you have [Elixir 1.14.0](https://elixir-lang.org/install.html) installed.

2.  Configure `config/config.exs` to custom tenants/users.

3.  Run the following commands

    ```bash
    mix deps.get
    mix amnesia.create -d Database --disk
    mix run --no-halt
    ```
