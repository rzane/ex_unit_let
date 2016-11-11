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
      setup_name = :"#{let_name}_setup"

      @ex_unit_let [{let_name, setup_name} | @ex_unit_let]

      defp unquote(let_name)(unquote(var)), unquote(block)

      defp unquote(setup_name)(context) do
        {:ok, Map.put(context, unquote(name), unquote(let_name)(context))}
      end

      setup setup_name
    end
  end

  defp escape(contents) do
    Macro.escape(contents, unquote: true)
  end
end
