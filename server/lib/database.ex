use Amnesia

defdatabase Database do
  deftable GoLink,
           [:id, :shortcut, :target_url, :user_id],
           type: :ordered_set do
    @type t() :: %__MODULE__{
            id: String.t(),
            shortcut: String.t(),
            target_url: String.t(),
            user_id: String.t()
          }
  end
end
