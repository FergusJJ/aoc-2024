defmodule Day3 do
  def solve_p1(input, enable \\ true) do
    Enum.reduce(input, {0, -1, 0, 0, 0, false, enable, 0}, fn ch, acc ->
      c = String.to_charlist(ch) |> hd()

      cond do
        c == 100 && elem(acc, 1) == -1 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 1}

        c == 111 && elem(acc, 1) == 100 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 1}

        Day3.is_lbrack(c) && elem(acc, 1) == 111 && elem(acc, 7) == 1 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 1}

        Day3.is_rbrack(c) && Day3.is_lbrack(elem(acc, 1)) && elem(acc, 7) == 1 ->
          {elem(acc, 0), -1, 0, 0, 0, false, true, 0}

        c == 110 && elem(acc, 1) == 111 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 2}

        c == 39 && elem(acc, 1) == 110 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 2}

        c == 116 && elem(acc, 1) == 39 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 2}

        Day3.is_lbrack(c) && elem(acc, 1) == 116 && elem(acc, 7) == 2 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), 2}

        Day3.is_rbrack(c) && Day3.is_lbrack(elem(acc, 1)) && elem(acc, 7) == 2 ->
          {elem(acc, 0), -1, 0, 0, 0, false, false, 0}

        c == 109 && elem(acc, 1) == -1 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}

        c == 117 && elem(acc, 1) == 109 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}

        c == 108 && elem(acc, 1) == 117 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}

        Day3.is_lbrack(c) && elem(acc, 1) == 108 ->
          {elem(acc, 0), c, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}

        Day3.is_comma(c) ->
          cond do
            Day3.is_int(elem(acc, 1)) ->
              {elem(acc, 0), c, 0, elem(acc, 3), 0, true, elem(acc, 6), elem(acc, 7)}

            true ->
              {elem(acc, 0), -1, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}
          end

        Day3.is_rbrack(c) ->
          cond do
            elem(acc, 5) && Day3.is_int(elem(acc, 1)) && elem(acc, 6) ->
              {elem(acc, 0) + elem(acc, 3) * elem(acc, 4), -1, 0, 0, 0, false, elem(acc, 6),
               elem(acc, 7)}

            true ->
              {elem(acc, 0), -1, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}
          end

        Day3.is_int(c) && elem(acc, 1) != -1 ->
          cond do
            Day3.is_lbrack(elem(acc, 1)) ->
              {elem(acc, 0), c, 1, c - ?0, 0, false, elem(acc, 6), elem(acc, 7)}

            Day3.is_comma(elem(acc, 1)) ->
              {elem(acc, 0), c, 1, elem(acc, 3), c - ?0, elem(acc, 5), elem(acc, 6), elem(acc, 7)}

            elem(acc, 2) < 3 ->
              cond do
                elem(acc, 5) ->
                  {elem(acc, 0), c, elem(acc, 2) + 1, elem(acc, 3),
                   Day3.update_num(elem(acc, 4), c - ?0), true, elem(acc, 6), elem(acc, 7)}

                true ->
                  {elem(acc, 0), c, elem(acc, 2) + 1, Day3.update_num(elem(acc, 3), c - ?0), 0,
                   false, elem(acc, 6), elem(acc, 7)}
              end

            true ->
              {elem(acc, 0), -1, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}
          end

        true ->
          {elem(acc, 0), -1, 0, 0, 0, false, elem(acc, 6), elem(acc, 7)}
      end
    end)
  end

  def solve_p2(input), do: solve_p1(input, true)
  def update_num(curr, next), do: if(curr == 0, do: next, else: next + curr * 10)
  def is_int(c), do: c > 47 && c < 58
  def is_lbrack(c), do: c == 40
  def is_rbrack(c), do: c == 41
  def is_comma(c), do: c == 44
end

File.read("day3/input.txt")
|> elem(1)
|> String.graphemes()
|> Day3.solve_p2()
|> elem(0)
|> IO.puts()
