defmodule Server.Auth.Plug do
  import Plug.Conn

  def init(opts), do: opts

  def call(conn, _opts) do
    validate_auth_params(conn)
  end

  # Validate if ?user_id= and ?api_key= are present in the request.
  defp validate_auth_params(conn) do
    with %{"api_key" => api_key} <- conn.params,
         {:ok, user} <- Server.Auth.UserLookup.lookup_by_api_key(api_key) do
      # Insert the user_id and api_key into the connection object.
      conn = assign(conn, :user_id, user.user_id)
      conn = assign(conn, :api_key, user.api_key)
      conn
    else
      # API key is invalid, return a 401 Unauthorized response.
      {:error, :not_found} ->
        conn
        |> send_resp(:unauthorized, Jason.encode!(%{error: "Invalid API key."}))
        |> halt()

      # API key is missing, return a 400 Bad Request response.
      _ ->
        conn
        |> send_resp(:bad_request, Jason.encode!(%{error: "Missing api_key parameter."}))
        |> halt()
    end
  end
end
