defmodule ExUnit.Let do
  @moduledoc ~S"""
  Defines `let` macros.

  There isn't much magic happening here. Essentially,

      let :name, do: "Ray"

  Is identical to:

      setup, do: [name: "Ray"]

  Likewise,

      let :something, %{other: other}, do: other + 1

  Is idential to:

      setup %{other: other}, do: [something: other + 1]
  """

  @doc false
  defmacro __using__(_) do
    quote do
      @ex_unit_let []
      import ExUnit.Let
    end
  end

  @doc """
  Defines a callback to be run before each test in a case.

  ## Examples

      let :number, do: 1
  """
  defmacro let(name, block) do
    do_let(name, quote(do: _), block)
  end

  @doc """
  Defines a callback to be run before each test in a case. Allows you
  to access previous context.

  ## Examples

      let :next_number, %{number: number}, do: number + 1
  """
  defmacro let(name, var, block) do
    do_let(name, var, block)
  end

  defp do_let(name, var, block) do
    quote bind_quoted: [name: name, var: escape(var), block: escape(block)] do
      # Generate a secret sequential function name
      let_name   = :"__ex_unit_let_#{length(@ex_unit_let)}"

      # Track the number of lets in order to generate unique names
      @ex_unit_let [let_name | @ex_unit_let]

      # Define a function that takes context as an argument
      defp unquote(let_name)(unquote(var)), unquote(block)

      # Call that function and merge in it's value
      setup context do
        Keyword.put([], unquote(name), unquote(let_name)(context))
      end
    end
  end

  defp escape(contents) do
    Macro.escape(contents, unquote: true)
  end
end
