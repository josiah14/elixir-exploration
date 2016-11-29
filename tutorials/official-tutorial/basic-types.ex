################
# Basic Types
################
## all eval to 'true'
is_integer(1)
is_integer(0x1F)
is_float(1.0)
is_boolean(true)
is_atom(:atom)
is_bitstring("elixir")
is_list([1, 2, 3])
is_tuple({1, 2, 3})

####################
# Basic Arithmetic
####################
1 + 2
#=> 3

5 * 5
#=> 25

10 / 2
#=> 5.0

div(10, 3)
#=> 3

div 10, 3
#=> 3

rem 10, 3
#=> 1

0b1010
#=> 10

0o777
#=> 511

0x1F
#=> 31

1.0e-10
#=> 1.0e-10

round(2.58)
#=> 3

trunc(2.58)
#=> 2

true
#=> true

true == false
#=> false

is_boolean(false)
#=> true

is_boolean(1)
#=> false

:hello == :hello
#=> true

:hello == :jello
#=> false

# booleans are atoms
true == :true
#=> true

is_atom(false)
#=> true

is_boolean(:false)
#=> true

###########
# Strings
###########

# Strings are utf-8 bitstrings
"hellö"
#=> "hellö"

"hellö #{:world}"
#=> "hellö world"

IO.puts "hello\nworld"
# hello
# world
#=> :ok

is_binary("hellö")
#=> true

# character 'ö' takes 2 bytes
byte_size("hellö")
#=> 6

String.length("hellö")
#=> 5

String.upcase("hellö")
#=> "HELLÖ"

######################
# Anonymous Functions
######################

add = fn a, b -> a + b end
#=> #Function<12.50752066/2 in :erl_eval.expr/5>

is_function(add)
#=> true

# the second param is arity
is_function(add, 2)
#=> true

is_function(add, 1)
#=> false

# Executing lambdas requires a '.'
add.(1, 2)
#=> 3

# Lambda/anonymous functions are closures
double = fn a -> add.(a, a) end
#=> #Function<6.50752066/1 in :erl_eval.expr/5>

double.(3)
#=> 6

# inner-scope variables do not affect outer scopes
x = 42
#=> 42

(fn -> x = 0 end).()
#=> 0

x
#=> 42

# But inner scopes can still access outer-scope variables
# Hence, it is possible to shadow outer-scope variables in inner-scopes
(fn -> x end).()
#=> 42

####################
# (Linked) Lists
####################

[1, 2, true, 3]
#=> [1, 2, true, 3]

length [1, 2, true, 3]
#=> 4

[1, 2, 3] ++ [4, 5, 6]
#=> [1, 2, 3, 4, 5, 6]

[1, true, 2, false, 3, true] -- [true, false]
#=> [1, 2, 3, true]

list = [1, 2, 3]
hd(list)
#=> 1
tl(list)
#=> [2, 3]

hd []
#=> %ArgumentError{message: "argument error"}

# If the list looks like ASCII chars, Elixir will print out their values
[11, 12, 13]
#=> '\v\f\r'

[104, 101, 108, 108, 111]
#=> 'hello'

# use `i` in iex to print out information about things

'hello' == 'hello'
#=> true

# the first is a char list, the second a bitstring, so they are not eq.
'hello' == "hello"
#=> false

####################
# Tuples
####################

{:ok, "hello"}
#=> {:ok, "hello"}

tuple_size {:ok, "hello"}
#=> 2

tuple = {:ok, "hello"}
#=> {:ok, "hello"}
elem(tuple, 1)
#=> "hello"

tuple_size(tuple)
#=> 2

put_elem tuple, 1, "world"
#=> {:ok, "world"}

# Error thrown when you surpass the size of the tuple
put_elem tuple, 2, "world"
#=> %ArgumentError{message: "argument error"}

#####################
# Lists or Tuples?
#####################

# Lists are linked
list = [1 | [2 | [ 3 | []]]]
#=> [1, 2, 3]

# makes prepending updates fast
# getting list size is slow because the entire list must be traversed
# getting by index can be slow - must traverse to index.
[0 | list]
#=> [0, 1, 2, 3]

# Tuples stored contiguously in mem
# getting tuple size and access by index is fast
# updating or adding elements is expensive on tuples -
# requires copying the entire tuple

# tuples often used to return extra information from a function.
File.read("/home/josiah/Documents/ubuntu16_04-apparmor_status.txt")
#=> {:ok, "apparmor module is loaded... <etc>"}
File.read("/a/bogus/path")
#=> {:error, :enoent}

elem({:ok, "hello"}, 1)
#=> "hello"
