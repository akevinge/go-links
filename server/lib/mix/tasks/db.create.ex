defmodule Mix.Tasks.Db.Create do
  @moduledoc """
  Mix task to create an Amnesia disk on the current node.
  """
  use Mix.Task

  @shortdoc "Create an Amnesia disk on the current node"
  def run(_) do
    Amnesia.Schema.create([node()])
    Amnesia.start()
    Database.create(disk: [node()])
  end
end
