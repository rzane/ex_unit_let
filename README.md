# ExUnit.Let

If you're coming from RSpec, you might be missing `let`. This is kind of like that, but also not at all.

ExUnit.Let is a really tiny shorthand for `setup`. It allows you to test like this:

```elixir
defmodule MyTest do
  use ExUnit.Case
  use ExUnit.Let

  let :a, do: 1
  let :b, %{a: a}, do: a + 1

  test "a", %{a: a} do
    assert a == 1
  end

  test "b", %{b: b} do
    assert b == 2
  end
end
```

Basically, the examples above just boil down to this:

```elixir
setup do: [a: 1]
setup %{a: a}, do: [a + 1]
```

It's not buying you much other than visual greppability.

## Installation

The package can be installed by adding `ex_unit_let` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:ex_unit_let, "~> 0.1.0", only: :test}]
    end
    ```
