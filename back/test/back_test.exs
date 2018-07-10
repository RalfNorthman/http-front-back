defmodule BackTest do
  use ExUnit.Case
  doctest Back

  test "greets the world" do
    assert Back.hello() == :world
  end
end
