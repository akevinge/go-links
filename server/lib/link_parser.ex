defmodule LinkParser do
  @moduledoc """
  Go link parsing utilities.
  """

  @doc """
    Remove the "go" prefix from a path, if it exists.

    ## Examples

        iex> LinkParser.remove_go_prefix("go/elixir")
        "elixir"

        iex> LinkParser.remove_go_prefix("go")
        ""

        iex> LinkParser.remove_go_prefix("elixir")
        "elixir"

        iex> LinkParser.remove_go_prefix("/go/elixir/123")
        "elixir/123"
  """
  @spec remove_go_prefix(String.t()) :: String.t()
  def remove_go_prefix(path_string) do
    path_string
    |> String.trim("/")
    |> String.replace_prefix("go", "")
    |> String.trim("/")
  end
end
