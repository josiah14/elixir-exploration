########################################
# Loops through Recursion
########################################

# Elixir does not permit mutating variables, so traditional, imperative looping does not exist as a language construct in Elixir.  Recursion is used, instead.

defmodule Recursion do
  def print_multiple_times(msg, n) when n <= 1 do
    IO.puts msg
  end

  def print_multiple_times(msg, n) do
    IO.puts msg
    print_multiple_times(msg, n - 1)
  end
end
Recursion.print_multiple_times("Hello!", 3)
#> Hello!
#> Hello!
#> Hello!
#=> :ok

# Similar to `case` statements, functions may have one or more clauses which add additional restrictions beyond just the number of arguments for determining which function definition gets executed.  In the above example, the clause is `n <= 1`.

########################################
# Reduce and Map Algorithms
########################################

# If the list has a head and a tail, the pattern match will succeed and use the first definition, else the list will be empty and use the second definition.
defmodule Math do
  def sum_list(list, accumulator \\ 0)

  def sum_list([head | tail], accumulator) do
    sum_list(tail, head + accumulator)
  end

  def sum_list([], accumulator) do
    accumulator
  end
end
Math.sum_list([1, 2, 3, 4, 5], 1) # should be 16
#=> 16
Math.sum_list([1, 2, 3, 4, 5]) # should be 15
#=> 15

defmodule Math do
  def double_each([head | tail]) do
    [head * 2 | double_each(tail)]
  end

  def double_each([]) do
    []
  end
end
Math.double_each([1, 2, 3])
#=> [2, 4, 6]

Enum.reduce([1, 2, 3], 0, fn(x, acc) -> x + acc end)
#=> 6

Enum.map([1, 2, 3], fn(x) -> x * 2 end)
#=> [2, 4, 6]

Enum.reduce([1, 2, 3], 0, &+/2)
#=> 6

Enum.map([1, 2, 3], &(&1 * 2))
#=> [2, 4, 6]
