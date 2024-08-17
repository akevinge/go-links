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

  plug(:match)
  plug(:dispatch)

  @template_dir "lib/templates"

  @spec redirect(Plug.Conn.t(), String.t(), integer | atom) :: no_return()
  defp redirect(conn, location, status) do
    conn
    |> put_resp_header("Location", location)
    |> send_resp(status, "Redirecting...")
  end

  @spec render(Plug.Conn.t(), integer | atom, String.t(), Keyword.t()) :: no_return()
  defp render(conn, status, template, assigns \\ []) do
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
    go_links = GoLink.get_all()
    render(conn, :ok, "index.html.eex", go_links: go_links)
  end

  get "/go/*shortcut" do
    # `shortcut` is a list of path segments.
    shortcut = shortcut |> Enum.join("/") |> String.trim("/")

    # Redirect to the target URL if the shortcut exists.
    case GoLink.get_by_shortcut(shortcut) do
      %GoLink{target_url: target_url} ->
        redirect(conn, target_url, :moved_permanently)

      nil ->
        render(conn, :not_found, "404.html.eex")
    end
  end

  delete "/go/*shortcut" do
    # `shortcut` is a list of path segments.
    shortcut = shortcut |> Enum.join("/") |> String.trim("/")

    # Delete the shortcut if it exists.
    case GoLink.delete_go_link(shortcut) do
      :ok ->
        send_resp(conn, :ok, "")

      _ ->
        send_resp(conn, :not_found, "")
    end
  end

  post "/go" do
    with %{"shortcut" => shortcut, "target_url" => target_url} <- conn.body_params,
         shortcut <- LinkParser.remove_go_prefix(shortcut),
         %GoLink{} <- GoLink.create_go_link(shortcut, target_url) do
      send_resp(conn, :created, "")
    else
      {:error, :already_exists} ->
        send_resp(conn, :conflict, "")

      _ ->
        send_resp(conn, :bad_request, "")
    end
  end

  match _ do
    render(conn, :not_found, "404.html.eex")
  end
end
