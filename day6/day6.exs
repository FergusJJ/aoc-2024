defmodule Day6 do
  def file_to_board(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.to_list()
  end

  def walk({i, j}, max_rows, max_cols, direction, board, visited, acc) do
    {next_i, next_j} =
      case direction do
        # north
        0 -> {i - 1, j}
        # east
        1 -> {i, j + 1}
        # south
        2 -> {i + 1, j}
        # west
        _ -> {i, j - 1}
      end

    cond do
      next_i < 0 || next_j < 0 || next_i >= max_rows || next_j >= max_cols ->
        acc

      true ->
        case Enum.at(Enum.at(board, next_i), next_j) do
          "#" ->
            walk(
              {i, j},
              max_rows,
              max_cols,
              (direction + 1) |> rem(4),
              board,
              visited,
              acc
            )

          _ ->
            case MapSet.member?(visited, {next_i, next_j}) do
              true ->
                walk(
                  {next_i, next_j},
                  max_rows,
                  max_cols,
                  direction,
                  board,
                  visited,
                  acc
                )

              _ ->
                walk(
                  {next_i, next_j},
                  max_rows,
                  max_cols,
                  direction,
                  board,
                  MapSet.put(visited, {next_i, next_j}),
                  acc + 1
                )
            end
        end
    end
  end

  def solve_p1(board) do
    max_rows = length(board)
    max_cols = length(Enum.at(board, 0))

    {pos_i, pos_j} =
      for {row, i} <- Enum.with_index(board),
          {val, j} <- Enum.with_index(row),
          val in ["v", ">", "<", "^"],
          reduce: nil do
        _acc -> {i, j}
      end

    direction =
      case Enum.at(Enum.at(board, pos_i), pos_j) do
        "^" -> 0
        ">" -> 1
        "v" -> 2
        _ -> 3
      end

    visited = MapSet.new()
    visited = MapSet.put(visited, {pos_i, pos_j})

    board =
      List.update_at(board, pos_i, fn row ->
        List.update_at(row, pos_j, fn _ -> "." end)
      end)

    walk({pos_i, pos_j}, max_rows, max_cols, direction, board, visited, 1)
  end
end

# Map of '^' | '>' | '<' | 'v', '.' and '#'
# '^' | '>' | '<' | 'v' -> Position of guard/direction she face
# '#' -> Positions of obstacles

# Guards do the following:
# If something in front of guard -> Turn 90 degrees right/clockwise
# Else take step forward

# Goal:
# Count num of _distinct_ positions that the guard is in before she leaves
# the map
# Method
# Parse into 2d-list
# find pos of guard (not sure what direction so check all)
# Increment total count, replace char with some 'visited char'
# While guard in map:
#   Follow facing direction, incrementing total if not visited
#   When next is obstacle, change diurection, follow new direction
#   Want to check next direction before moving guar, change diurection, follow new direction
#   Want to check next direction before moving guard.

Day6.file_to_board("day6/input.txt")
|> Day6.solve_p1()
|> IO.inspect()
