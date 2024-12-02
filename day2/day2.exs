defmodule Day2 do
  def solve_p1(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " ", trim: true))
    |> Stream.map(fn line ->
      nums = Enum.map(line, &String.to_integer/1)
      [first | rest] = nums

      Enum.reduce(rest, {true, 0, first}, fn x, acc ->
        sign = x - elem(acc, 2)

        case abs(sign) > 0 and abs(sign) < 4 and elem(acc, 0) do
          false ->
            {false, 0, x}

          true ->
            case elem(acc, 1) == 0 do
              true -> {true, if(sign > 0, do: 1, else: -1), x}
              false -> {sign * elem(acc, 1) > 0, elem(acc, 1), x}
            end
        end
      end)
      |> elem(0)
    end)
    |> Enum.frequencies()
    |> Map.get(true, 0)
    |> IO.inspect()
  end

  def solve_p2(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, " ", trim: true))
    |> Stream.map(fn line ->
      nums = Enum.map(line, &String.to_integer/1)

      sequences =
        for i <- 0..(length(nums) - 1) do
          List.delete_at(nums, i)
        end

      Enum.any?(sequences, fn seq ->
        [first | rest] = seq

        Enum.reduce(rest, {true, 0, first}, fn x, acc ->
          sign = x - elem(acc, 2)

          case abs(sign) > 0 and abs(sign) < 4 and elem(acc, 0) do
            false ->
              {false, 0, x}

            true ->
              case elem(acc, 1) == 0 do
                true -> {true, if(sign > 0, do: 1, else: -1), x}
                false -> {sign * elem(acc, 1) > 0, elem(acc, 1), x}
              end
          end
        end)
        |> elem(0)
      end)
    end)
    |> Enum.frequencies()
    |> Map.get(true, 0)
    |> IO.inspect()
  end
end

# One report per line
# Each number (level) must be strictly increasing or decreasing
# n = n +/- 1 or 3
# IO.gets("Input file: ")
# |> String.trim()
# |> Day2.solve_p1()

IO.gets("Input file: ")
|> String.trim()
|> Day2.solve_p2()
