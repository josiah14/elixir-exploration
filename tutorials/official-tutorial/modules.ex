String.length("hello")
#=> 5

# def and defmodule are both macros
defmodule Math do
  def sum(a, b) do
    a + b
  end
end
Math.sum(1, 2)
#=> 3

########################################
# Compilation
########################################

# Most of the time, it is convenient to write modules into files so they can be compiled and reused.  Let's assume we have a file named `math.ex` with the following contents:

defmodule Math do
  def sum(a, b) do
    a + b
  end
end

# This file can be compiled using elixirc:
# `$ elixirc math.ex`
# This will generate a file named `Elixir.Math.beam` containing the bytecode for the defined module.  If we start `iex` again, our module definition will be available.

# Elixir projects are usually organized into three directories
#     - ebin - contains the compiled bytecode
#     - lib - contains elixir code (usually .ex files)
#     - test - contains tests (usually .exs files)

########################################
# Scripted Mode
########################################

# In addition to the Elixir file extension, `.ex`, Elixir also supports `.exs` filse for scripting.  Elixir treats both files exactly the same way, the only difference is in intention.  `.ex` files are meant to be compiled while `.exs` files are used for scripting.  When executed, both extensions compile and load their modules into memory, although only `.ex` files write their bytecode to disk in the format of `.beam` files.

# For instance, we can create a file called `math.exs`:

defmodule Math do
  def sum(a, b) do
    a + b
  end
end
IO.puts Math.sum(1, 2)

# and execute it as: `$ elixir math.exs`

########################################
# Named Functions
########################################

# `def` defines public functions, `defp` defines private ones
defmodule Math do
  def sum(a, b) do
    do_sum(a, b)
  end

  defp do_sum(a, b) do
    a + b
  end
end

IO.puts Math.sum(1, 2)
#>> 3
#=> :ok
IO.puts Math.do_sum(1, 2)
#>> ** (UndefinedFunctionError)
#=> %UndefinedFunctionError{arity: 2, function: :do_sum, module: Math, reason: nil}

# Function declarations support guards and multiple clauses.
1 + 1

defmodule Math do
  def zero?(0) do
    true
  end

  def zero?(x) when is_integer(x) do
    false
  end
end

Math.zero?(0)
#=> true
Math.zero?(1)
#=> false
Math.zero?([1, 2, 3])
#=> %FunctionClauseError{arity: 1, function: :zero?, module: Math}
#=>> ** (FunctionClauseError)
Math.zero?(0.0)
#=> %FunctionClauseError{arity: 1, function: :zero?, module: Math}
#=>> ** (FunctionClauseError)

# ^ Giving arguments that don't match any of the clauses raises an error.

# Using keywords:
defmodule Math do
  def zero?(0), do: true
  def zero?(x) when is_integer, do: false
end
# ^ The above is exactly the same as the definition which precedes it.

########################################
# Function Capturing
########################################

defmodule Math do
  def zero?(0), do: true
  def zero?(x) when is_integer(x), do: false
end
fun = &Math.zero?/1
#=> &Math.zero?/1
is_function(fun)
#=> true
fun.(0)
#=> true

&is_function/1
#=> &:erlang.is_function/1
(&is_function/1).(fun)
#=> true

fun = &(&1 + 1)
#=> #Function<6.50752066/1 in :erl_eval.expr/5>
fun.(5)
#=> 6

fun = &List.flatten(&1, &2)
#=> &List.flatten/2
fun.([1, [[2], 3]], [4, 5])
#=> [1, 2, 3, 4, 5]

########################################
# Default Arguments
########################################

# Only named functions support default arguments

defmodule Concat do
  # Default value is denoted by the `\\` operator
  def join(a, b, sep \\ " ") do
    a <> sep <> b
  end
end
Concat.join("Hello", "world!")
#=> "Hello world!"
Concat.join("Hello", "world!", "_")
#=> "Hello_world!"

# Any expression may serve as a default value
defmodule DefaultTest do
  def dowork(x \\ IO.puts "hello") do
    x
  end
end
DefaultTest.dowork
#> hello
#=> :ok
DefaultTest.dowork 123
#=> 123

# If a function with default argument values has multiple clauses, the function is required to have a function head for declaring the defaults:
defmodule Concat do
  # Function head
  def join(a, b \\ nil, sep \\ " ")

  def join(a, b, _sep) when is_nil(b) do
    a
  end

  def join(a, b, sep) do
    a <> sep <> b
  end
end
Concat.join("Hello", "world")
#=> "Hello world"
Concat.join("Hello", "world", "_")
#=> "Hello_world"
Concat.join("Hello")
#=> "Hello"

# Be careful to avoid overlapping function definitions
defmodule Concat do
  def join(a, b) do
    IO.puts "***First join"
    a <> b
  end

  def join(a, b, sep \\ " ") do
    IO.puts "***Second join"
    a <> sep <> b
  end
end
#=>> warning: this clause cannot match because a previous clause at line 3 always matches

# The above warning occurs because calling join with 2 arguments will always call the first definition of join, which negates the value of giving `sep` a default value.
