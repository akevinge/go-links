defmodule Server.Auth.User do
  defstruct user_id: nil, api_key: nil
end

defmodule Server.Auth.UserLookup do
  @moduledoc """
  This module is responsible for looking up users by their API key.
  """
  alias Server.Auth.User

  use GenServer

  @server_name {:global, __MODULE__}

  # Client methods.

  @doc """
  Lookup a user by their API key.
  """
  @spec lookup_by_api_key(String.t()) :: {:ok, User.t()} | {:error, :not_found}
  def lookup_by_api_key(api_key) do
    GenServer.call(@server_name, {:lookup_by_api_key, api_key})
  end

  # Server callbacks.

  def start_link(_args) do
    GenServer.start_link(__MODULE__, [], name: @server_name)
  end

  @impl GenServer
  def init(_args) do
    users = load_config!()
    {:ok, users}
  end

  @impl GenServer
  def handle_call({:lookup_by_api_key, api_key}, _from, users) do
    case Enum.find(users, &(&1.api_key == api_key)) do
      nil -> {:reply, {:error, :not_found}, users}
      user -> {:reply, {:ok, user}, users}
    end
  end

  defmodule NoUsersConfiguredException do
    defexception message: "No users configured in config/config.exs"
  end

  defmodule InvalidUserException do
    defexception message: "Invalid user, missing either user_id or api_key"
  end

  # Load the users from the config.
  @spec load_config!() :: [User.t()]
  defp load_config!() do
    case Application.get_env(:go_links, :user_api_keys) do
      nil -> raise NoUsersConfiguredException
      [] -> raise NoUsersConfiguredException
      users -> users
    end
    |> Enum.map(&validate_user!/1)
  end

  # Ensure that the user is valid (i.e. has a user_id and api_key).
  @spec validate_user!(User.t()) :: User.t()
  defp validate_user!(user) do
    if Map.get(user, :user_id) == nil || Map.get(user, :api_key) == nil do
      raise InvalidUserException
    end

    user
  end
end
