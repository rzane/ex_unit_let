defmodule ExUnit.Let do
  defmacro __using__(_) do
    quote do
      @ex_unit_let []
      import ExUnit.Let
    end
  end

  defmacro let(name, block) do
    do_let(name, quote(do: _), block)
  end

  defmacro let(name, var, block) do
    do_let(name, var, block)
  end

  defp do_let(name, var, block) do
    quote bind_quoted: [name: name, var: escape(var), block: escape(block)] do
      # Generate a secret sequential function name
      let_name   = :"__ex_unit_let_#{length(@ex_unit_let)}"

      # Track the number of lets
      @ex_unit_let [let_name | @ex_unit_let]

      # Define a function that takes context as an argument
      defp unquote(let_name)(unquote(var)), unquote(block)

      # Call that function and merge in it's value
      setup context do
        {:ok, Map.put(context, unquote(name), unquote(let_name)(context))}
      end
    end
  end

  defp escape(contents) do
    Macro.escape(contents, unquote: true)
  end
end
