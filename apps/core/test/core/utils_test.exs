defmodule HTMLParsec.Core.UtilsTest do
  use ExUnit.Case, async: true

  alias HTMLParsec.Core.Utils
  alias HTMLParsec.Core.Parser
  alias HTMLParsec.Core.HTTPClientAdapter

  describe "valid_adapter?/1" do
    defmodule ValidAdapter do
      @moduledoc false

      @behaviour HTTPClientAdapter

      @impl HTTPClientAdapter
      def fetch(text), do: fn -> text end
    end

    defmodule InvalidAdapter, do: nil

    test "returns the module if given module implements the behaviour" do
      assert ValidAdapter == Utils.valid_adapter?(ValidAdapter)
    end

    test "raises if module doesn't implements the behaviour" do
      assert_raise RuntimeError, fn -> Utils.valid_adapter?(InvalidAdapter) end
    end
  end

  describe "valid_parsers?/1" do
    defmodule ValidParser do
      @moduledoc false

      @behaviour Parser

      @impl Parser
      def parse(text), do: fn -> text end

      @impl Parser
      def accumulator_key(), do: "accumulator_key"
    end

    defmodule InvalidParser, do: nil

    test "returns the module names if given modules implements the behaviour" do
      assert [ValidParser] == Utils.valid_parsers?([ValidParser])
    end

    test "raises if module doesn't implements the behaviour" do
      assert_raise RuntimeError, fn -> Utils.valid_parsers?([InvalidParser]) end
    end
  end
end
