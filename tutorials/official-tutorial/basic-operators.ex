########################################
# ++ and -- for working with Lists
########################################

[1, 2, 3] ++ [4, 5, 6]
#=> [1, 2, 3, 4, 5, 6]

[1, 2, 4, 3, 4] -- [2, 4]
#=> [1, 3, 4]

########################################
# String Concatenation
########################################
"foo" <> "bar"
#=> "foobar"

########################################
# Boolean Operators
########################################
true and true
#=> true

false or is_atom(:example)
#=> true

# Numbers are not booleans... Ever
1 and true
#=> %ArgumentError{message: "argument error: 1"}

# Boolean logic shortcuts
false and raise("This error will never be raised")
#=> false

true or raise("This error will never be raised")
#=> true

# ||, &&, and ! accept arguments of any type.  false and nil are the only falsy values.
1 || true
#=> 1
false || 11
#=> 11

nil && 13
#=> nil
true && 17
#=> 17

!true
#=> false
!1
#=> false
!nil
#=> true

# Convention: use and, or, and not when expecting booleans, otherwise use &&, ||, and ! if either arguments is expected to be a non-boolean.

1 == 1
#=> true

1 != 2
#=> true

1 < 2
#=> true

# The difference between == and === is the latter is more strict concerning Integer to Float comparisons
1 == 1.0
#=> true
1 === 1.0
#=> false

# However, you CAN compare two different data types.  This is done so that sorting algorithms don't need to worry about different data types in order to sort.
1 < :atom
#=> true

# Sorting order
# number < atom < reference < function < port < pid < tuple < map < list < bitstring
