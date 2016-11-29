########################################
# UTF-8 and Unicode
########################################

string = "hello"
is_binary(string)
#=> true

string = "hełło"
# count bytes
byte_size(string)
#=> 7
# count characters
String.length(string)
#=> 5

# ? gets a character's code point
?a
#=> 97
?ł
#=> 322

String.codepoints("hełło")
#=> ["h", "e", "ł", "ł", "o"]

########################################
# Binaries and Bitstrings (which are binaries)
########################################
# how to work with binaries and bitstrings
<<0, 1, 2, 3>>
#=> <<0, 1, 2, 3>>
byte_size(<<0, 1, 2, 3>>)
#=> 4

String.valid?(<<239, 191, 191>>)
#=> false

<<0, 1>> <> <<2, 3>>
#=> <<0, 1, 2, 3>>

# append/concat the null byte to see a string's binary representation

"hełło" <> <<0>>
#=> <<104, 101, 197, 130, 197, 130, 111, 0>>

# Only numbers up to but not including 256 are valid bytes.  Larger bytes start over from 0.
<<255>>
#=> <<255>>
<<256>>
#=> <<0>>
<<257>>
#=> <<1>>

# Of course, you could define the chunk size
<<256 :: size(16)>> # 2 bytes
#=> <<1, 0>>
<<400 :: size(16)>> # 2 bytes
#=> <<1, 144>>
<<256 :: utf8>>
#=> "Ā"
<<256 :: utf8, 0>>
#=> <<196, 128, 0>>

# If the bits aren't divisible by 8 (a byte), then it's a bitstring, which is just a 'bunch' of bits
is_binary(<<1 :: size(1)>>)
#=> false
is_bitstring(<<1 :: size(1)>>)
#=> true
bit_size(<<1 :: size(1)>>)
#=> 1

# A binary is a bitstring where the number of bits is divisible by 8
is_binary(<<1 :: size(16)>>)
#=> true
is_binary(<<1 :: size(15)>>)
#=> false
is_bitstring(<<1 :: size(15)>>)
#=> true

<<0, 1, x>> = <<0, 1, 2>>
x
#=> 2

<<0, 1, x>> = <<0, 1, 2, 3>>
#=> %MatchError{term: <<0, 1, 2, 3>>}
#=>> ** (MatchError) no match of right hand side value: <<0, 1, 2, 3>>

<<0, 1, x :: binary>> = <<0, 1, 2, 3>>
#=> <<0, 1, 2, 3>>
x
#=> <<2, 3>>

"he" <> rest = "hello"
#=> "hello"
rest
#=> "llo"

########################################
# Char Lists
########################################

# Char lists are defined using single quotes
'hełło'
#=> [104, 101, 322, 322, 111]
is_list 'hełło'
#=> true
is_list "hełło"
#=> false
List.first('hełło')
#=> 104

to_charlist "hełło"
#=> [104, 101, 322, 322, 111]
to_string 'hełło'
#=> "hełło"
to_string :hello
#=> "hello"
to_string 1
#=> "1"
