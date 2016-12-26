# All code in Elixir runs inside 1 or more processes.  Unlike threads, which may share memory, processes are totally isolated from each other.  Processes form the basis for concurrent, distributed, and fault-tolerant applications in Elixir (after the Erlang model).

# Elixir processes are not the same as OS processes; they are much more lightweight in terms of memory and cpu, even more-so than threads in most other languages.  It is not uncommon in Elixir to have hundreds of thousands of simultaneously active processes.

########################################
# `spawn`
########################################

# Spawn is the basic mechanism for creating new processes, and is part of the Elixir standard library

pid = spawn fn -> 1 + 2 end
#=> #PID<0.88.0>
Process.alive? pid
#=> true

# Get the current pid
cpid = self
#=> #PID<0.47.0>
Process.alive? self
#=> true

########################################
# `send` and `receive`
########################################

# `send` and `receive` provide an inter-proc message passing mechanism

# Messages wait in a proc's mailbox until `receive` picks them up.
# If `receive` doesn't have any patterns that match a message in the mailbox,
# the messages just sit and wait - receive doesn't throw an error (unless an
# imposed timeout has been reached).

send self, {:hello, "hello!"}
send self, {:world, "world!"}
receive do
  {:hello, msg} -> msg <> " world"
  {:world, msg} -> "hello " <> msg
end
#=> "hello! world"
receive do
  {:hello, msg} -> msg <> " world"
  {:world, msg} -> "hello " <> msg
end
#=> "hello world!"

receive do
  {:foobar, msg} -> msg
after
  1_000 -> "nothing after 1s"
end
#=> "nothing after 1s"

# *** A timeout of 0 can be used when you expect something to already be in the mailbox

## Sending messages between procs

parent = self
#=> #PID<0.47.0>
spawn fn -> send(parent, {:hello, self}) end
#=> #PID<0.89.0>
receive do
  {:hello, pid} -> "pid: #{inspect self} got hello from pid: #{inspect pid}"
end
#=> "pid: #PID<0.47.0> got hello from pid: #PID<0.89.0>"

# in iex, `flush/0` flushes and prints all of the messages in `self`'s mailbox.
# flush only exists in iex, it is not part of the Elixir standard library.

########################################
# Links
########################################

# `spawn_link` is actually the most commonly used function to `spawn` a new proc.

# To understand the benefit of `spawn_link/1`, one must know what happens when a proc fails.
spawn fn -> raise "oops" end
#=> #PID<0.91.0>
#
#   17:45:22.478 [error] Process #PID<0.91.0> raised an exception
#   ** (RuntimeError) oops
#   :erlang.apply/2

# It logs an error to stderr, but the proc is still running!
# This is because procs are isolated!
pid = spawn fn -> raise "oops" end
Process.alive? pid
#=> true

# In order to link the failure in one process to another process, we need to link the 2 procs (using `spawn_link/1`)
spawn_link fn -> raise "oops" end
#=> ** (EXIT from #PID<0.58.0>) an exception was raised:
#     ** (RuntimeError) oops
#         :erlang.apply/2

# When a failure happens in a shell, the shell traps the failure and displays it.  Here's what would happen if you made a file and ran it.

# spawn.exs
spawn_link fn -> raise "oops" end
receive do
  :hello -> "let's wait until the process fails"
end

#=> ** (EXIT from #PID<0.47.0>) an exception was raised:
#       ** (RuntimeError) oops
#           spawn.exs:1: anonymous fn/o in :elixir_compiler_0.__FILE__/1

# It brings down both procs since they are linked

########################################
# Tasks
########################################

# Tasks are wrappers around the Spawn functions that try to provide better error reporting and introspection.

Task.start fn -> raise "oops" end
#=> {:ok, #PID<0.88.0>}
#   (no error logger present) error: <0.41.0>
#   (no error logger present) error: <0.44.0>
#   (no error logger present) error: <0.39.0>
#
#=>> 15:06:24.569 [error] Task #PID<0.60.0> started from #PID<0.58.0> terminating
#    ** (RuntimeError) oops
#        (elixir) lib/task/supervised.ex:94: Task.Supervised.do_apply/2
#        (stdlib) proc_lib.erl:240: :proc_lib.init_p_do_apply/3
#    Function: #Function<20.50752066/0 in :erl_eval.expr/5>
#        Args: []

# Use Task.start/1 and Task.start_link/1 in place of spawn/1 and spawn_link/1.  The return values from Task functions allows them to be used in supervision trees

########################################
# State
########################################

defmodule KV do
  def start_link do
    Task.start_link(fn -> loop(%{}) end)
  end

  defp loop(map) do
    receive do
      {:get, key, caller} ->
        send caller, Map.get(map, key)
        loop(map)
      {:put, key, value} ->
        loop(Map.put(map, key, value))
    end
  end
end

{:ok ,pid} = KV.start_link
#=> {:ok, #PID<0.92.0>}
send pid, {:put, :name, :josiah}
#=> {:put, :name, :josiah}
send pid, {:get, :name, self()}
#=> {:get, :name, #PID<0.47.0>}
receive do
  name -> IO.puts name
end
#=>> josiah
#=> :ok

# Giving processes names

{:ok ,pid} = KV.start_link
#=> {:ok, #PID<0.92.0>}
Process.register(pid, :kv)
#=> true
send :kv, {:put, :name, :slim_shady}
#=> {:put, :name, :josiah}
send :kv, {:get, :name, self()}
#=> {:get, :josiah, #PID<0.47.0>}
receive do
  name -> "My name is *chka chka* - #{name}"
end
#=>> "My name is *chka chka* - slim_shady"

######################################
# Agents - Abstractions around Links
######################################

{:ok, pid} = Agent.start_link(fn -> %{} end, name: :hello_world)
#=> {:ok, #PID<0.88.0>}
Agent.update(:hello_world, fn map -> Map.put(map, :hello, :world) end)
#=> :ok
Agent.get(:hello_world, fn map -> Map.get(map, :hello) end)
#=> :world
