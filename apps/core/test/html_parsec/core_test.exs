defmodule HTMLParsec.CoreTest do
  use ExUnit.Case
  doctest HTMLParsec.Core

  test "greets the world" do
    assert HTMLParsec.Core.hello() == :world
  end
end
