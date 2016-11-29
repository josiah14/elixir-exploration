########################################
# Case
########################################

# Compare a value against many patterns until there's a match
case {1, 2, 3} do
  {4, 5, 6} -> "This won't match"
  {1, x, 3} -> "This will match and bind x to #{x}"
  _ -> "This matches any value, but only if the clauses above it don't match"
end
#=> "This will match and bind x to 2"
# variables in case statements don't carry back to the encompasing scope
x
#=> %CompileError{description: "undefined function x/0", file: "nofile", line: 7}

# if you want to pattern match against an existing variable, you need to use the point operator.
x = 1
#=> 1
case 10 do
  ^x -> "Won't match"
  _ -> "Will match"
end
#=> "Will match"

case {1, 2, 3} do
  {1, x, 3} when x > 0 -> "Will match"
  _ -> "Would match, if guard condition weren't satisfied"
end
#=> "Will match"

case {1, -2, 3} do
  {1, x, 3} when x > 0 -> "Won't match: x isn't positive"
  _ -> "Will match"
end
#=> "Will match"

########################################
# Expressions in Guard Clauses
########################################

# The following expressions may be used in guards by default.

# Comparison operators (==, !=, ===, !==, >, >=, <, <=)
# Boolean operators (and, or, not)
# Arithmetic operations (+, -, *, /)
# Arithmetic unary operators (+, -)
# The binary concatenation operator, <>
# the `in` operator as long as the right side is a range or a list
# All the following type check functions
#   is_atom/1
#   is_binary/1
#   is_bitstring/1
#   is_boolean/1
#   is_float/1
#   is_function/1
#   is_function/2
#   is_integer/1
#   is_list/1
#   is_map/1
#   is_nil/1
#   is_number/1
#   is_pid/1
#   is_port/1
#   is_reference/1
#   is_tuple/1
# And also these functions:
#   abs(number)
#   binary_part(binary, start, length)
#   bit_size(bitstring)
#   byte_size(bitstring)
#   div(integer, integer)
#   elem(tuple, n)
#   hd(list)
#   length(list)
#   map_size(map)
#   node()
#   node(pid | ref | port)
#   rem(integer, integer)
#   round(number)
#   self()
#   tl(list)
#   trunc(number)
#   tuple_size(tuple)

# Additionally, users may define their own guards.  For example, the Bitwise module defines guards as functions and operators:
#   bnot
#   ~~~
#   band
#   &&&
#   bor
#   |||
#   bxor
#   ^^^
#   bsl
#   <<<
#   bsr
#   >>>

# *Special Note*, while boolean ops `and`, `or`, and `not` are allowed in guards, the more general `&&`, `||`, and `!` aren't permitted.

# Errors in guards don't leak, but, instead, make the guard fail.
hd(1)
#=> ArgumentError{message: "argument error"}
case 1 do
  x when hd(x) -> "Won't match"
  x -> "Got #{x}"
end
#=> "Got 1"

# An error will be raised if none of the case patterns match.
case :ok do
  :error -> "Won't match"
end
#=> %CaseClauseError{term: :ok}
#=>> * (CaseClauseError) no case clause matching: :ok

# You can conditionally define implementation...
f = fn
  x, y when x > 0 -> x + y
  x, y -> x * y
end
#=> #Function<12.50752066/2 in :erl_eval.expr/5>
f.(1, 3)
#=> 4
f.(-1, 3)
#=> -3

# But not arity.
f2 = fn
  x, y when x > 0 -> x + y
  x, y, z -> x * y + z
end
#=> %CompileError{description: "cannot mix clauses with different arities in function definition", file: "nofile", line: 1}

########################################
# Cond
########################################

# `case` is useful when we want to delegate execution by matching against different values, but in many circumstances, we want to check different conditions and find the first one that's true.  The latter is what `cond` allows us to do.

cond do
  2 + 2 == 5 -> "This won't be true"
  2 * 2 == 3 -> "Neither will this be true"
  1 + 1 == 2 -> "This is true, though"
end
#=> "This is true, though"

# Cond is a replacement for the if, else if, else construct used in most imperative languages
# If none of the conditions returns true, a `CondClauseError` is raised.  Use `true` as the final condidion as a fail-safe catch-all.
cond do
  2 + 2 == 5 -> "Never true"
  2 * 2 == 3 -> "Also never true"
  true -> "Always true - use this as the default cond"
end
#=> "Always true - use this as the default cond"

# Everything is truthy except `nil` and `false`
cond do
  hd([1, 2, 3]) -> "1 is considered as true"
end
#=> "1 is considered as true"

########################################
# `if` and `unless`
########################################

# Besides `case` and `cond`, Elixir also provides the macros `if/2` and `unless/2`
# These are useful if you only need to check one condition.
if true do
  "This works!"
end
#=> "This works!"

unless false do
  "This works, too!"
end
#=> "This works, too!"

if false do
  "If the condition fails, it returns `nil`"
end
#=> nil

if nil do
  "This won't be seen"
else
  "Else blocks are also supported"
end
#=> "Else blocks are also supported"

unless true do
  "This won't be seen"
else
  "Else blocks are also supported by `unless`"
end
#=> "Else blocks are also supported by `unless`"

########################################
# `do/end` Blocks
########################################

# We could also use `if` statements as follows:
if true, do: 1 + 2
#=> 3

# The above `, do:` syntax is called a `keyword list`.
# :else is also a keyword
if false, do: :this, else: :that
#=> :that

# The below 2 are equivalent
if true do
  a = 1 + 2
  a + 10
end
#=> 13

if true, do: (
  a = 1 + 2
  a + 10
)
#=> 13

is_number (if true, do: 1 + 2)
