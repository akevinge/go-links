import Config

config :go_links,
  port: 4040,
  user_api_keys: [
    %{
      user_id: "CHANGE_ME_1",
      api_key: "CHANGE_ME_1"
    },
    %{
      user_id: "CHANGE_ME_2",
      api_key: "CHANGE_ME_2"
    }
  ]

# config :amnesia,
#   dir: "/home/kevin/env/go-links/server/Mnesia.nonode@nohost"
# _build/prod/rel/go_links/bin/go_links start
