########################################
# The `IO` Module
########################################

# The IO module is the main mechinism for writing and reading to/from stdout/stdin, stderr, files, and other IO devices.

# Basic usage is as follows

IO.puts "hello, world!"
#=>> hello, world!
#=> :ok

IO.gets "yes or no? "
#=>> yes or no? <input>yes
#=> "yes\n"

# To write to stderr (or something else)

IO.puts :stderr, "Oh, crap!"
#=>2> Oh, crap!
#=> :ok

########################################
# The `File` Module
########################################
