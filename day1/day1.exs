defmodule Day1 do
  def parse_file({:ok, body}) do
    # split body by \n then split into tuples by " "
    # tuple ith index in ith list
    # return lists
    String.split(body, "\n")
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.filter(fn list -> length(list) == 2 end)
    |> Enum.reduce({[], []}, fn [l, r], {list1, list2} ->
      {[l | list1], [r | list2]}
    end)
  end

  def parse_file({:error, reason}) do
    {:error, "Failed to read file #{reason}"}
  end

  def get_answer_p1({list1, list2}) do
    Enum.map([list1, list2], &Enum.sort/1)
    |> Enum.zip()
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
  end

  def get_answer_p2({list1, list2}) do
    freq_map = Enum.frequencies(list2)

    Enum.reduce(list1, 0, fn val, acc ->
      case Map.fetch(freq_map, val) do
        {:ok, occurrences} -> acc + occurrences * val
        :error -> acc
      end
    end)
  end
end

# "day1/input.txt"
# |> File.read()
# |> Day1.parse_file()
# |> Day1.get_answer_p1()

# "day1/input.txt"
# |> File.read()
# |> Day1.parse_file()
# |> Day1.get_answer_p2()
