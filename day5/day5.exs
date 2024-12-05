defmodule Day5 do
  def parse_input(filename) do
    [raw_rules, raw_updates] =
      File.read!(filename)
      |> String.split("\n\n")
      |> Enum.to_list()

    [raw_updates, parse_rules(raw_rules)]
  end

  def parse_rules(rules) do
    rules
    |> String.split("\n")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.reject(&(&1 == ""))
    |> Stream.map(&String.split(&1, "|"))
    |> Enum.reduce(%{}, fn [x0, x1], acc ->
      k = String.to_integer(x1)
      v = String.to_integer(x0)
      Map.update(acc, k, [v], fn xs -> [v | xs] end)
    end)
  end

  def get_middle(update) do
    middle = div(length(update), 2)
    Enum.at(update, middle)
  end

  def is_valid?(update, rules) do
    Enum.all?(rules, fn {k, vs} ->
      Enum.all?(vs, fn v ->
        case {k in update, v in update} do
          {true, true} ->
            k_index = Enum.find_index(update, &(&1 == k))
            v_index = Enum.find_index(update, &(&1 == v))
            k_index > v_index

          _ ->
            true
        end
      end)
    end)
  end

  def solve_p1(updates, rules) do
    updates
    |> String.split("\n")
    |> Stream.map(&String.trim_trailing/1)
    |> Stream.map(&String.split(&1, ",", trim: true))
    |> Stream.reject(&(&1 == []))
    |> Stream.map(&Enum.map(&1, fn num -> String.to_integer(String.trim(num)) end))
    |> Enum.reduce({0, []}, fn update, {sum, invalid_updates} ->
      if is_valid?(update, rules) do
        {sum + get_middle(update), invalid_updates}
      else
        {sum, [update | invalid_updates]}
      end
    end)
  end

  def sort_update(update, rules) do
    sorted = []
    remaining = update

    Enum.reduce_while(1..length(update), {sorted, remaining}, fn _, {sorted, remaining} ->
      next_satisfied =
        Enum.find(remaining, fn curr ->
          Enum.all?(remaining, fn rest ->
            prerequisites = Map.get(rules, rest, [])
            curr not in prerequisites
          end)
        end)

      case next_satisfied do
        nil -> {:halt, {sorted, remaining}}
        curr -> {:cont, {[curr | sorted], List.delete(remaining, curr)}}
      end
    end)
  end

  def solve_p2(updates, rules) do
    updates
    |> Enum.reduce(0, fn update, acc ->
      {sorted, _} = sort_update(update, rules)
      acc + get_middle(sorted)
    end)
  end
end

# Section 1: Page ordering
# a|b -> if a and b both in an update, a must happen before b

# Section 2: Page numbers of each update (linewise)

[raw_updates, rules] = Day5.parse_input("./day5/input.txt")
{p1, invalid_updates} = Day5.solve_p1(raw_updates, rules)
IO.inspect(p1)

Day5.solve_p2(invalid_updates, rules)
|> IO.inspect()
