########################################
# Keyword Lists
########################################

list = [{:a, 1}, {:b, 2}]
#=> [a: 1, b: 2]
list == [a: 1, b: 2]
#=> true
list ++ [c: 3]
#=> [a: 1, b: 2, c: 3]
[a: 0] ++ list
#=> [a: 0, a: 1, b: 2]
new_list = [ {:a, 0} | list ]
#=> [a: 0, a: 1, b: 2]
new_list[:a]
#=> 0

# Keys must be atoms, keys are ordered as specified by the developer, and keys can be given more than once
# Keyword lists are, therefore, the default mechanism for passing options to functions in Elixir.

if false, do: :this, else: :that
#=> :that

# The above uses keyword lists
# And it is equivalent to the below

if(false, [do: :this, else: :that])
#=> that

# Which is the same as the below:

if(false, [{:do, :this}, {:else, :that}])
#=> :that

[a: a] = [a: 1]
#=> [a: 1]
a
#=> 1

# obviously mismatches due to mismatch is number of items
[a: a] = [a: 1, b: 2]
#=> %MatchError{term: [a: 1, b: 2]}
#=>> ** (MatchError) no match of right hand side value: [a: 1, b: 2]

# This mismatches due to ordering
[b: b, a: a] = [a: 1, b: 2]
#=> %MatchError{term: [a: 1, b: 2]}
#=>> ** (MatchError) no match of right hand side value: [a: 1, b: 2]

########################################
# Maps
########################################

map = %{:a => 1, 2 => :b}
#=> %{2 => :b, :a => 1}
map[:a]
#=> 1
map[2]
#=> :b
map[:c]
#=> nil

# Maps are not ordered and multiple of the same key is not allowed
%{} = %{:a => 1, 2 => :b}
#=> %{2 => :b, :a => 1}
%{:a => a} = %{:a => 1, 2 => :b}
#=> %{2 => :b, :a => 1}
a
#=> 1
%{:c => c} = %{:a => 1, 2 => :b}
#=> %MatchError{term: %{2 => :b, :a => 1}}
#=>> ** (MatchError) no match of right hand side value: %{2 => :b, :a => 1}

n = 1
map = %{n => :one}
map[n]
#=> :one
%{^n => :one} = %{1 => :one, 2 => :two, 3 => :three}
#=> %{1 => :one, 2 => :two, 3 => :three}

Map.get(%{:a => 1, 2 => :b}, :a)
#=> 1
Map.to_list(%{:a => 1, 2 => :b})
#=> [{2, :b}, {:a, 1}]

# Shorthand when all the keys are atoms
map = %{a: 1, b: 2}
#=> %{a: 1, b: 2}
map.a
#=> 1
map.c
#=> %KeyError{key: :c, term: %{a: 1, b: 2}}
#=>> ** (KeyError) key :c not found in: %{a: 1, b: 2}

# change the value of something in a map
map = %{a: 1, b: 2}
%{map | :a => 2}
#=> %{a: 2, b: 2}
map
#=> %{a: 1, b: 2}
%{map | :c => 3}
#=> %KeyError{key: :c, term: %{a: 1, b: 2}}
#=>> (KeyError) key :c not found in: %{2 => :b, :a => 1}

########################################
# Nested Data Structures
########################################

users = [
  john: %{name: "John", age: 27, languages: ["Erlang", "Ruby", "Elixir"]},
  mary: %{name: "Mary", age: 29, languages: ["Elixir", "F#", "Clojure"]}
]
#=> [john: %{age: 27, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
#    mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}]
users[:john].age
#=> 27
users = put_in users[:john].age, 31
#=> [john: %{age: 31, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
#    mary: %{age: 29, languages: ["Elixir", "F#", "Clojure"], name: "Mary"}]

# update_in allows us to pass a function that controls how the value changes.
users = update_in users[:mary].languages, &List.delete(&1, "Clojure")
#=> [john: %{age: 31, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
#    mary: %{age: 29, languages: ["Elixir", "F#"], name: "Mary"}]

# Warning!  These functions cause side-effects!
users
#=> [john: %{age: 31, languages: ["Erlang", "Ruby", "Elixir"], name: "John"},
#    mary: %{age: 29, languages: ["Elixir", "F#"], name: "Mary"}]
