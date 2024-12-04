defmodule Day4 do
  def file_to_board(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.graphemes/1)
    |> Enum.to_list()
  end

  def dfs(board, {r, c}, direction) do
    current = Enum.at(Enum.at(board, r), c)

    cond do
      current == "S" ->
        1

      true ->
        num_rows = length(board)
        num_cols = length(Enum.at(board, 0))

        dirs = [
          [r + 1, c],
          [r - 1, c],
          [r, c + 1],
          [r, c - 1],
          [r + 1, c + 1],
          [r + 1, c - 1],
          [r - 1, c - 1],
          [r - 1, c + 1]
        ]

        case direction do
          -1 ->
            result =
              Enum.reduce(Enum.with_index(dirs), 0, fn {[dr, dc], index}, acc ->
                cond do
                  dr < 0 || dr >= num_rows || dc < 0 || dc >= num_cols ->
                    acc

                  true ->
                    next = Enum.at(Enum.at(board, dr), dc)

                    if next == "M" do
                      res = dfs(board, {dr, dc}, index)
                      acc + res
                    else
                      acc
                    end
                end
              end)

            result

          0 ->
            [dr, dc] = Enum.at(dirs, 0)

            cond do
              dr >= num_rows ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 0)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 0)

              true ->
                0
            end

          1 ->
            [dr, dc] = Enum.at(dirs, 1)

            cond do
              dr < 0 ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 1)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 1)

              true ->
                0
            end

          2 ->
            [dr, dc] = Enum.at(dirs, 2)

            cond do
              dc >= num_cols ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 2)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 2)

              true ->
                0
            end

          3 ->
            [dr, dc] = Enum.at(dirs, 3)

            cond do
              dc < 0 ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 3)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 3)

              true ->
                0
            end

          4 ->
            [dr, dc] = Enum.at(dirs, 4)

            cond do
              dr >= num_rows || dc >= num_cols ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 4)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 4)

              true ->
                0
            end

          5 ->
            [dr, dc] = Enum.at(dirs, 5)

            cond do
              dr >= num_rows || dc < 0 ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 5)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 5)

              true ->
                0
            end

          6 ->
            [dr, dc] = Enum.at(dirs, 6)

            cond do
              dr < 0 || dc < 0 ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 6)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 6)

              true ->
                0
            end

          7 ->
            [dr, dc] = Enum.at(dirs, 7)

            cond do
              dr < 0 || dc >= num_cols ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 7)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 7)

              true ->
                0
            end

          _ ->
            0
        end
    end
  end

  def solve_p1(board) do
    Enum.reduce(Enum.with_index(board), 0, fn {row, r}, acc ->
      Enum.reduce(Enum.with_index(row), acc, fn {ch, c}, acc ->
        case ch do
          "X" ->
            acc + dfs(board, {r, c}, -1)

          _ ->
            acc
        end
      end)
    end)
  end

  def dfs_p2(board, {r, c}, direction) do
    current = Enum.at(Enum.at(board, r), c)

    cond do
      current == "S" ->
        1

      true ->
        num_rows = length(board)
        num_cols = length(Enum.at(board, 0))

        dirs = [
          [r + 1, c + 1],
          [r + 1, c - 1],
          [r - 1, c - 1],
          [r - 1, c + 1]
        ]

        case direction do
          -1 ->
            result =
              Enum.reduce(Enum.with_index(dirs), 0, fn {[dr, dc], index}, acc ->
                cond do
                  dr < 0 || dr >= num_rows || dc < 0 || dc >= num_cols ->
                    acc

                  true ->
                    next = Enum.at(Enum.at(board, dr), dc)

                    if next == "M" do
                      res = dfs(board, {dr, dc}, index)
                      acc + res
                    else
                      acc
                    end
                end
              end)

            result

          0 ->
            [dr, dc] = Enum.at(dirs, 0)

            cond do
              dr >= num_rows || dc >= num_cols ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 0)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 0)

              true ->
                0
            end

          1 ->
            [dr, dc] = Enum.at(dirs, 1)

            cond do
              dr >= num_rows || dc < 0 ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 1)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 1)

              true ->
                0
            end

          2 ->
            [dr, dc] = Enum.at(dirs, 2)

            cond do
              dr < 0 || dc < 0 ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 2)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 2)

              true ->
                0
            end

          3 ->
            [dr, dc] = Enum.at(dirs, 3)

            cond do
              dr < 0 || dc >= num_cols ->
                0

              Enum.at(Enum.at(board, dr), dc) == "A" && Enum.at(Enum.at(board, r), c) == "M" ->
                dfs(board, {dr, dc}, 3)

              Enum.at(Enum.at(board, dr), dc) == "S" && Enum.at(Enum.at(board, r), c) == "A" ->
                dfs(board, {dr, dc}, 3)

              true ->
                0
            end

          _ ->
            0
        end
    end
  end

  def solve_p2(board) do
    num_rows = length(board)
    num_cols = length(Enum.at(board, 0))

    Enum.reduce(Enum.with_index(board), 0, fn {row, r}, acc ->
      Enum.reduce(Enum.with_index(row), acc, fn {_, c}, acc ->
        cond do
          c + 2 >= num_cols || r + 2 >= num_rows ->
            acc

          true ->
            curr = Enum.at(Enum.at(board, r), c)
            down_right = Enum.at(Enum.at(board, r + 2), c + 2)
            down = Enum.at(Enum.at(board, r + 2), c)
            right = Enum.at(Enum.at(board, r), c + 2)
            middle = Enum.at(Enum.at(board, r + 1), c + 1)

            cond do
              middle != "A" ->
                acc

              ((curr == "M" && down_right == "S") ||
                 (curr == "S" && down_right == "M")) &&
                  ((right == "M" && down == "S") ||
                     (right == "S" && down == "M")) ->
                acc + 1

              true ->
                acc
            end
        end
      end)
    end)
  end
end

# wordsearch
# can up l, r, u, d, diag
board = Day4.file_to_board("./day4/input.txt")

Day4.solve_p1(board)
|> IO.inspect()

Day4.solve_p2(board)
|> IO.inspect()
