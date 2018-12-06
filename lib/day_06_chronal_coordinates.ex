defmodule Adventofcode.Day06ChronalCoordinates do
  use Adventofcode

  def manhattan_distance({x1, y1}, {x2, y2}), do: abs(x1 - x2) + abs(y1 - y2)
end
