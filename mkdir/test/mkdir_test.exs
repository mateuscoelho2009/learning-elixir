defmodule MkdirTest do
  use ExUnit.Case
  doctest Mkdir

  test "greets the world" do
    assert Mkdir.hello() == :world
  end
end
