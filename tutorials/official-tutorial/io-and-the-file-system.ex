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

# Files are opened in binary mode by default (Yay!).

{:ok, file} = File.open "hello", [:write]
#=> {:ok, #PID<0.88.0>}
IO.binwrite file, "world"
#=> :ok
File.close file
#=> :ok
File.read "hello"
#=> {:ok, "world"}

# File module also contains commands for working with the filesystem which mimick their UNIX equivallents.

File.read "hello"
#=> {:ok, "world"}
File.read! "hello"
#=> "world"
# If anything goes wrong, bang functions raise an error instead of indicating an error in a returned tuple.
File.read "unknown"
#=> {:error, :enoent}
File.read! "unknown"
#=> %File.Error{action: "read file", path: "unknown", reason: :enoent}

case File.read("hello") do
  {:ok, body}      -> IO.puts "yay"
  {:error, reason} -> IO.puts "oops"
end
#=>> yay
#=> :ok

# The bang version is useful when you expect the file to be there, and its absence should interrupt normal program execution.

########################################
# The `Path` Module
########################################

Path.join("foo", "bar")
#=> "foo/bar"
Path.expand("~/hello")
#=> "/home/josiah/hello"

########################################
# Processes and group leaders
########################################

pid = spawn fn ->
  receive do: (msg -> IO.inspect msg)
end
#=> #PID<0.100.0>
IO.write(pid, "hello")
#=>
# {:io_request, #PID<0.47.0>, #Reference<0.0.2.1995>,
# {:put_chars, :unicode, "hello"}}
# %ErlangError{original: :terminated}

{:ok, pid} = StringIO.open("hello")
#=> {:ok, #PID<0.102.0>}
IO.read(pid, 2)
#=> "he"

IO.puts :stdio, "hello"
#=>> hello
#=> :ok

IO.puts Process.group_leader, "hello"
#=>> hello
#=> :ok

########################################
# `iodata` and `chardata` Module
########################################

IO.puts 'hello world'
#=>> hello world
#=> :ok

# You can print a mixed list of lists, integers, and binaries
IO.puts ['hello', ?\s, "world"]
#=>> hello world
#=> :ok
