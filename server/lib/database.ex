use Amnesia

defdatabase Database do
  deftable GoLink,
           [:shortcut, :target_url],
           type: :ordered_set do
    @type t() :: %__MODULE__{
            shortcut: String.t(),
            target_url: String.t()
          }

    @doc """
    Get all go links.
    """
    @spec get_all() :: [t()]
    def get_all() do
      Amnesia.transaction do
        keys()
        |> match
        |> Amnesia.Selection.values()
      end
    end

    @doc """
    Create a new go link.
    """
    @spec create_go_link(String.t(), String.t()) :: t() | {:error, :already_exists}
    def create_go_link(shortcut, target_url) do
      Amnesia.transaction do
        cond do
          not member?(shortcut) ->
            %GoLink{shortcut: shortcut, target_url: target_url}
            |> write()

          true ->
            {:error, :already_exists}
        end
      end
    end

    @doc """
    Delete a go link.
    """
    @spec delete_go_link(String.t()) :: :ok | {:error, :not_found}
    def delete_go_link(shortcut) do
      Amnesia.transaction do
        cond do
          not member?(shortcut) ->
            {:error, :not_found}

          true ->
            delete(shortcut)
        end
      end
    end

    @doc """
    Get a go link by shortcut.
    """
    @spec get_by_shortcut(String.t()) :: t() | nil
    def get_by_shortcut(shortcut) do
      Amnesia.transaction do
        read(shortcut)
      end
    end
  end
end
