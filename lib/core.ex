defmodule HTMLParsec.Core do
  @moduledoc false

  alias HTMLParsec.Application

  @match_pattern {:"$1", :"$2", :_}
  @empty_guards []
  @body [{{:"$1", :"$2"}}]

  def fetch(url), do: Application.start_child(url)

  def get_urls() do
    HTMLParsec.Registry
    |> Registry.select([{@match_pattern, @empty_guards, @body}])
    |> Enum.map(fn {url, _pid} -> url end)
  end

  def get_pid(url) do
    HTMLParsec.Registry
    |> Registry.select([{@match_pattern, [{:==, :"$1", url}], @body}])
    |> Enum.map(fn {_url, pid} -> pid end)
    |> List.first()
  end
end
