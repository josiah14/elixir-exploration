########################################
# The Match Operator
########################################
x = 1
#=> 1
x
#=> 1

# The = operator is called the 'match' operator.
1 = x
#=> 1
2 = x
#=> %MatchError{term: 1}
#=>> ** (MatchError) no match of right hand side value: 1

# A variable can only be assigned on the left side of =, though.
1 = new_var
#=> %CompileError{description: "undefined function new_var/0", file: "nofile", line: 1}
#=>> ** (CompileError) iex:1: undefined function new_var/0

{a, b, c} = {:hello, "world", 42}
#=> {:hello, "world", 42}
a
#=> :hello
b
#=> "world"

{a, b, c} = {:hello, "world"}
#=> %MatchError{term: {:hello, "world"}}
#=>> ** (MatchError) no match of right hand side value: [:hello, "world", 42]

{:ok, result} = {:ok, 13}
#=> {:ok, 13}
result
#=> 13

# Strangely, this reassigns result... BEWARE
{:ok, result} = {:ok, :oops}
#=> {:ok, :oops}
result
#=> :oops

{:jigglypuff, result} = {:ok, :oops}
#=> %MatchError{term: {:ok, :oops}}
#=>> ** (MatchError) no match of right hand side value: {:ok, :oops}

# Pattern Matching on Lists
[a, b, c] = [1, 2, 3]
#=> [1, 2, 3]
a
#=> 1

[head | tail] = [1, 2, 3]
#=> [1, 2, 3]
head
#=> 1
tail
#=> [2, 3]

[head | tail] = []
#=> %MatchError{term: []}
#=>> ** (MatchError) no match of right hand side value: []

# [head | tail] format is not only used for pattern matching, but also for prepending items to a list.
list = [1, 2, 3]
#=> [1, 2, 3]
[0 | list]
#=> [0, 1, 2, 3]
[1 | [2, 3]] = list
#=> [1, 2, 3]

########################################
# The Pin Operator
########################################

# variable can be rebound
x = 1
#=> 1
x = 2
#=> 2

# use the pin operator, ^, when you want to pattern match against an existing variable's value rather than rebinding the variable
x = 1
#=> 1
^x = 2
#=> %MatchError{term: 2}
#=>> ** (MatchError) no match of right hand side value: 2
x = 1
{y, ^x} = {2, 1}
#=> {2, 1}
y
#=> 2
{y, ^x} = {2, 1}
#=> {2, 1}
{y, ^x} = {2, 2}
#=> %MatchError{term: {2, 2}}
#=>> ** (MatchError) no match of right hand side value: {2, 2}

{y, 1} = {2, 2}
#=> %MatchError{term: {2, 2}}
#=>> ** (MatchError) no match of right hand side value: {2, 2}

# if a variable is mentioned more than once in a pattern, all references need to bind to the same pattern.
{x, x} = {1, 1}
#=> {1, 1}
{x, x} = {1, 2}
#=> %MatchError{term: {1, 2}}
#=>> ** (MatchError) no match of right hand side value: {1, 2}

# In some cases, you don't care about a particular value in a pattern.  It's a common practice to bind those values to `_`.
[h | _] = [1, 2, 3]
#=> [1, 2, 3]
h
#=> 1
_
#=> %CompileError{description: "unbound variable _", file: "nofile", line: 5}
#=>> (CompileError) iex:1: unbound variable _

# You cannot make function calls on the left side of a match
length([1, [2], 3]) = 2
#=> %CompileError{description: "illegal pattern", file: "nofile", line: 1}
#=>> ** (CompileError) iex:1: illegal pattern
