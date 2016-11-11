defmodule ExUnit.LetTest do
  use ExUnit.Case
  use ExUnit.Let

  doctest ExUnit.Let

  let :a, do: 1
  let :b, %{a: a}, do: a + 1

  test "declares an attribute" do
    assert length(@ex_unit_let) == 2
  end

  test "passes through without context", %{a: a} do
    assert a == 1
  end

  test "passes through with context", %{b: b} do
    assert b == 2
  end

  describe "when used with describe" do
    let :c, do: 3

    test "declares an attribute" do
      assert length(@ex_unit_let) == 3
    end

    test "passes through with describe", %{c: c} do
      assert c == 3
    end

    test "passes through shared without context", %{a: a} do
      assert a == 1
    end

    test "passes through share with context", %{b: b} do
      assert b == 2
    end
  end

  test "doesn't leak let out of describe", context do
    refute context[:c]
  end

  test "continues to increment despite not leaking" do
    assert length(@ex_unit_let) == 3
  end
end
