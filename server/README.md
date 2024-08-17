# Go Link Server (Elixir Implementation)

## Run

1.  Ensure you have [Elixir 1.14.0](https://elixir-lang.org/install.html) installed.

2.  Configure `config/config.exs` to custom tenants/users.

3.  Run the following commands

    **Development**:

    ```bash
    mix deps.get
    mix amnesia.create -d Database --disk
    mix run --no-halt
    ```

    **Production**:

    ```bash
    mix deps.get
    MIX_ENV=prod elixir --erl "-name go_links@$HOSTNAME" -S mix db.create
    MIX_ENV=prod mix release
    _build/prod/rel/go_links/bin/go_links start
    ```
