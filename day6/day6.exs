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

  def get_next_position(i, j, direction) do
    case direction do
      0 -> {i - 1, j}
      1 -> {i, j + 1}
      2 -> {i + 1, j}
      _ -> {i, j - 1}
    end
  end

  def collect_all_visited({i, j}, max_rows, max_cols, direction, board, visited) do
    {next_i, next_j} = get_next_position(i, j, direction)

    cond do
      next_i < 0 || next_j < 0 || next_i >= max_rows || next_j >= max_cols ->
        visited

      true ->
        case Enum.at(Enum.at(board, next_i), next_j) do
          "#" ->
            collect_all_visited(
              {i, j},
              max_rows,
              max_cols,
              rem(direction + 1, 4),
              board,
              visited
            )

          _ ->
            if MapSet.member?(visited, {next_i, next_j}) do
              collect_all_visited(
                {next_i, next_j},
                max_rows,
                max_cols,
                direction,
                board,
                visited
              )
            else
              collect_all_visited(
                {next_i, next_j},
                max_rows,
                max_cols,
                direction,
                board,
                MapSet.put(visited, {next_i, next_j})
              )
            end
        end
    end
  end

  def walk_check_loop({i, j}, max_rows, max_cols, direction, board, visited) do
    {next_i, next_j} = get_next_position(i, j, direction)

    cond do
      next_i < 0 || next_j < 0 || next_i >= max_rows || next_j >= max_cols ->
        false

      true ->
        case Enum.at(Enum.at(board, next_i), next_j) do
          "#" ->
            new_direction = rem(direction + 1, 4)
            key = {i, j, new_direction}

            if MapSet.member?(visited, key) do
              true
            else
              walk_check_loop(
                {i, j},
                max_rows,
                max_cols,
                new_direction,
                board,
                MapSet.put(visited, key)
              )
            end

          _ ->
            key = {next_i, next_j, direction}

            if MapSet.member?(visited, key) do
              true
            else
              walk_check_loop(
                {next_i, next_j},
                max_rows,
                max_cols,
                direction,
                board,
                MapSet.put(visited, key)
              )
            end
        end
    end
  end

  def process_visited(board, start_pos, start_direction, visited) do
    max_rows = length(board)
    max_cols = length(Enum.at(board, 0))
    {start_i, start_j} = start_pos

    Enum.reduce(visited, 0, fn {i, j}, acc ->
      # Skip the starting position
      if {i, j} == {start_i, start_j} do
        acc
      else
        board =
          List.update_at(board, i, fn row ->
            List.update_at(row, j, fn _ -> "#" end)
          end)

        result =
          walk_check_loop(
            start_pos,
            max_rows,
            max_cols,
            start_direction,
            board,
            MapSet.new([{start_i, start_j, start_direction}])
          )

        board =
          List.update_at(board, i, fn row ->
            List.update_at(row, j, fn _ -> "." end)
          end)

        if result, do: acc + 1, else: acc
      end
    end)
  end

  def solve_p2(board) do
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

    visited =
      collect_all_visited({pos_i, pos_j}, max_rows, max_cols, direction, board, visited)

    process_visited(board, {pos_i, pos_j}, direction, visited)
  end
end

Day6.file_to_board("day6/input.txt")
|> Day6.solve_p2()
|> IO.inspect()

Day6.file_to_board("day6/input.txt")
|> Day6.solve_p1()
|> IO.inspect()
