defmodule Server.Router do
  use Plug.Router
  use Database.GoLink

  require LinkParser
  require Logger
  require Jason

  alias Database.GoLink

  plug(Plug.Logger, log: :info)

  plug(Plug.Static, at: "/assets", from: "priv/static")

  plug(Plug.Parsers,
    parsers: [:json],
    json_decoder: Jason
  )

  plug(Server.Auth.Plug)

  plug(:match)
  plug(:dispatch)

  @template_dir "lib/templates"

  # Redirect to a location with a status code.
  @spec redirect(Plug.Conn.t(), String.t(), integer | atom) :: no_return()
  defp redirect(conn, location, status) do
    conn
    |> put_resp_header("Location", location)
    |> send_resp(status, "Redirecting...")
  end

  # Render a template with assigns.
  @spec render(Plug.Conn.t(), integer | atom, String.t(), Keyword.t()) :: no_return()
  defp render(conn, status, template, assigns) do
    body =
      @template_dir
      |> Path.join(template)
      |> EEx.eval_file(assigns)

    send_resp(conn, status, body)
  end

  get "/" do
    redirect(conn, "/go", :moved_permanently)
  end

  get "/go" do
    user_id = conn.assigns[:user_id]
    api_key = conn.assigns[:api_key]

    go_links = GoLinks.get_all(user_id)
    render(conn, :ok, "index.html.eex", go_links: go_links, api_key: api_key)
  end

  get "/go/*shortcut" do
    user_id = conn.assigns[:user_id]
    api_key = conn.assigns[:api_key]

    # `shortcut` is a list of path segments.
    shortcut = shortcut |> Enum.join("/") |> String.trim("/")

    # Redirect to the target URL if the shortcut exists.
    case GoLinks.get_by_shortcut(user_id, shortcut) do
      %GoLink{target_url: target_url} ->
        redirect(conn, target_url, :moved_permanently)

      nil ->
        render(conn, :not_found, "404.html.eex", api_key: api_key)
    end
  end

  delete "/go/*shortcut" do
    user_id = conn.assigns[:user_id]

    # `shortcut` is a list of path segments.
    shortcut = shortcut |> Enum.join("/") |> String.trim("/")

    # Delete the shortcut if it exists.
    case GoLinks.delete_go_link(user_id, shortcut) do
      :ok ->
        send_resp(conn, :ok, "")

      _ ->
        send_resp(conn, :not_found, "")
    end
  end

  post "/go" do
    user_id = conn.assigns[:user_id]

    with %{"shortcut" => shortcut, "target_url" => target_url} <- conn.body_params,
         shortcut <- LinkParser.remove_go_prefix(shortcut),
         %GoLink{} <- GoLinks.create_go_link(user_id, shortcut, target_url) do
      send_resp(conn, :created, "")
    else
      {:error, :already_exists} ->
        send_resp(conn, :conflict, "")

      _ ->
        send_resp(conn, :bad_request, "")
    end
  end

  match _ do
    api_key = conn.assigns[:api_key]
    render(conn, :not_found, "404.html.eex", api_key: api_key)
  end
end
