defmodule GoLinks do
  use Amnesia
  use Database

  alias Database.GoLink

  @id_separator "--"

  # Format a unique ID for a go link per user.
  @spec format_unique_id(String.t(), String.t()) :: String.t()
  defp format_unique_id(user_id, shortcut) do
    "#{user_id}#{@id_separator}#{shortcut}"
  end

  @doc """
  Get all go links owned by a user.
  """
  @spec get_all(String.t()) :: [GoLink.t()]
  def get_all(by_user_id) do
    Amnesia.transaction do
      Amnesia.Selection.values(GoLink.where(user_id == by_user_id))
    end
  end

  @doc """
  Create a new go link for a user.
  """
  @spec create_go_link(String.t(), String.t(), String.t()) ::
          GoLink.t() | {:error, :already_exists}
  def create_go_link(user_id, shortcut, target_url) do
    id = format_unique_id(user_id, shortcut)

    Amnesia.transaction do
      cond do
        not GoLink.member?(id) ->
          %GoLink{id: id, shortcut: shortcut, target_url: target_url, user_id: user_id}
          |> GoLink.write()

        true ->
          {:error, :already_exists}
      end
    end
  end

  @doc """
  Delete a go link by shortcut and user ID.
  """
  @spec delete_go_link(String.t(), String.t()) :: :ok | {:error, :not_found}
  def delete_go_link(user_id, shortcut) do
    id = format_unique_id(user_id, shortcut)

    Amnesia.transaction do
      cond do
        not GoLink.member?(id) ->
          {:error, :not_found}

        true ->
          GoLink.delete(id)
      end
    end
  end

  @doc """
  Get a go link by shortcut and user ID.
  """
  @spec get_by_shortcut(String.t(), String.t()) :: GoLink.t() | nil
  def get_by_shortcut(user_id, shortcut) do
    id = format_unique_id(user_id, shortcut)

    Amnesia.transaction do
      GoLink.read(id)
    end
  end
end
