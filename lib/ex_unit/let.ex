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
      let_name   = :"__ex_unit_let_#{length(@ex_unit_let)}"
      @ex_unit_let [let_name | @ex_unit_let]

      defp unquote(let_name)(unquote(var)), unquote(block)

      setup context do
        {:ok, Map.put(context, unquote(name), unquote(let_name)(context))}
      end
    end
  end

  defp escape(contents) do
    Macro.escape(contents, unquote: true)
  end
end
