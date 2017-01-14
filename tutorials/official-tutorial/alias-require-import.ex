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
