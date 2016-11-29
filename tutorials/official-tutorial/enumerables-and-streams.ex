########################################
# Enumerables
########################################

# Lists and Maps are Enumerables
Enum.map([1, 2, 3], fn x -> x * 2 end)
#=> [2, 4, 6]

Enum.map(%{1 => 2, 3 => 4}, fn {k, v} -> k * v end)
#=> [2, 12]

# Ranges (the edges are inclusive)
Enum.map(1..3, fn x -> x * 2 end)
#=> [2, 4, 6]

Enum.reduce(1..3, 0, &+/2)
#=> 6

########################################
# Eager vs Lazy
########################################

# The Enum module is Eager (and all of its functions)
# This means that when performing multiple ops with Enum, each op will generate an intermediate collection until the final result is computed.
odd? = &(rem(&1, 2) != 0)
#=> #Function<6.50752066/1 in :erl_eval.expr/5>
Enum.filter(1..3, odd?)
#=> [1, 3]
1..100_000 |> Enum.map(&(&1 * 3)) |> Enum.filter(odd?) |> Enum.sum
#=> 7500000000

# Above, the first result is a list of 100_000 items.  Second result is a list of all 100_000 items multiplied by 3.  Third result is only the odd elements of the last list, which now will have only 50_000 items.  The last op sums all of these items.

# Equivalent to the piping, above:
Enum.sum(Enum.filter(Enum.map(1..100_000, &(&1 * 3)), odd?))
#=> 7500000000

########################################
# Streams
########################################

# Streams are just lazy, composable Enums

odd? = &(rem(&1, 2) != 0)
1..100_000 |> Stream.map(&(&1 * 3)) |> Stream.filter(odd?) |> Enum.sum
#=> 7500000000

# In the above pipeline, `1..100_000 |> Stream.map(&(&1 * 3))` doesn't return a list or range, but a Stream that represents a `map` computation over the range `1..100_000`

1..100_000 |> Stream.map(&(&1 * 3))
#=> #Stream<[enum: 1..100000, funs: [#Function<46.89908360/1 in Stream.map/2>]]>

# The pipe operator `|>` is the Stream composition operator

# Streams are useful when working with potentially infinite collections.

# Streams can receive Enumerables, but will (almost always) return a Stream.

# Functions that turn an Enumerable into a Stream:
# cycle takes an enum and eternally repeats it
stream = Stream.cycle([1, 2, 3])
#=> #Function<59.89908360/2 in Stream.unfold/2>
Enum.take(stream, 10)
#=> [1, 2, 3, 1, 2, 3, 1, 2, 3, 1]

# WARNING: Calling `Enum.map` on the above `stream` variable would result in an infinite recursion.

# Unfold takes an Enum and converts it as-is to a Stream
stream = Stream.unfold("hełło", &String.next_codepoint/1)
Enum.take(stream, 10)
#=> ["h", "e", "ł", "ł", "o"]
# *** No need to worry about exceeding the number of elements, it just returns what it can

# Stream.resource/3 is used to wrap resources to guarantee they are opened right before enumeration and then closed when finished (even in the case of failures).

stream = File.stream!("./math.exs")
Enum.take(stream, 10)
#=> ["defmodule Math do\n", "  def sum(a, b) do\n", "    a + b\n", "  end\n", "end\n", "IO.puts Math.sum(1, 2)\n", "\n"]
