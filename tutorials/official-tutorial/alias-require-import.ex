########################################
# `alias`
########################################

defmodule Stats do
  alias Math.List, as: List
  # In the remaining module def, List expands to Math.List.
end
#=>
# warning: unused alias List
# nofile:2
# {:module, Stats,
#  <<70, 79, 82, 49, 0, 0, 4, 28, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 94,
#  131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115,
#  95, 118, 49, 108, 0, 0, 0, 4, 104, 2, ...>>, Math.List}

# The following is equivalent to the above module def.
defmodule Stats do
  alias Math.List
  # In the remaining module def, List expands to Math.List.
end
#=>
# warning: unused alias List
# nofile:2
# {:module, Stats,
#  <<70, 79, 82, 49, 0, 0, 4, 28, 66, 69, 65, 77, 69, 120, 68, 99, 0, 0, 0, 94,
#  131, 104, 2, 100, 0, 14, 101, 108, 105, 120, 105, 114, 95, 100, 111, 99, 115,
#  95, 118, 49, 108, 0, 0, 0, 4, 104, 2, ...>>, Math.List}

# alias is "lexically scoped"

defmodule Math do
  def plus(a, b) do
    # The below alias only applies to the `plus` function
    alias Math.List
    # ...
  end

  def minus(a, b) do
    # ...
  end
end

########################################
# `require`
########################################

# require guarantees that a module's definitions are available at compile time (necessary for working with and using Macros)

Integer.is_odd(3)
#=> %UndefinedFunctionError{arity: 1, function: :is_odd, module: Integer, reason: nil}

require Integer
Integer.is_odd(3)
#=> true

########################################
# `import`
########################################

# Used to access functions or macros from other modules without using the fully-qualified name.

import List, only: [duplicate: 2]
#=> List
duplicate :ok, 3
#=> [:ok, :ok, :ok]

# import only macros
import Integer, only: :macros

# import only functions
import Integer, only: :functions

# Import is also lexically scoped.  I won't waste my time with an example identical to the one provide for `require`

########################################
# `use`
########################################

# allows you to use a module in the current context.
# Often used to bring in external modules, like the ExUnit testing framework.

# use is implemented through `require`, using the `__using__/1` callback on the module to inject code into the current context.

defmodule AssertionTest do
  use ExUnit.Case, async: true

  test "always pass" do
    assert true
  end
end
# The above is complied into...
defmodule AssertionTest do
  require ExUnit.Case
  ExUnit.Case.__using__(async: true)

  test "always pass" do
    assert true
  end
end

# Multiple Aliases, requires, imports, etc.
alias MyApp.{Foo, Bar, Baz}
