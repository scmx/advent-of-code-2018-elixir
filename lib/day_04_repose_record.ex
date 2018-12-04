defmodule Adventofcode.Day04ReposeRecord do
  use Adventofcode

  @enforce_keys [:date_time, :min, :message, :guard_id]
  defstruct [:date_time, :min, :message, :guard_id, :last_min]

  @record_regex ~r/^\[(.+)\] (.+)$/
  @guard_id_regex ~r/Guard #(\d+) begins shift/

  def parse_record(record_text) do
    [_, date, message] = Regex.run(@record_regex, record_text)

    {:ok, date} = NaiveDateTime.from_iso8601("#{date}:00")
    {_, min, _} = Time.to_erl(date)
    guard_id = find_guard_id(message)

    %__MODULE__{date_time: date, min: min, message: message, guard_id: guard_id}
  end

  def guard_minute(input) do
    input
    |> parse_records
    |> Enum.filter(&(&1.message == "wakes up"))
    |> collect_sleep_minutes_for_guards
    |> most_asleep_guard
    |> most_asleep_minute
  end

  defp parse_records(input) do
    input
    |> String.trim("\n")
    |> String.split("\n")
    |> Enum.sort()
    |> Enum.map(&parse_record/1)
    |> assign_guard_ids
    |> assign_last_min
  end

  def collect_sleep_minutes_for_guards(records) do
    Enum.reduce(records, %{}, fn record, guards ->
      guards
      |> Map.put_new(record.guard_id, %{})
      |> Map.update(record.guard_id, %{}, &collect_guard_sleep(&1, record))
    end)
  end

  defp collect_guard_sleep(minutes, record) do
    Enum.reduce(record.last_min..(record.min - 1), minutes, fn minute, acc ->
      Map.update(acc, minute, 1, &(&1 + 1))
    end)
  end

  defp find_guard_id(message) do
    case Regex.run(@guard_id_regex, message) do
      nil -> nil
      [_, id] -> String.to_integer(id)
    end
  end

  defp assign_guard_ids(records) do
    records
    |> Enum.map_reduce(nil, &do_assign_guard_id/2)
    |> elem(0)
  end

  defp do_assign_guard_id(record, guard_id) do
    if record.guard_id do
      {record, record.guard_id}
    else
      {%{record | guard_id: guard_id}, guard_id}
    end
  end

  defp assign_last_min(records) do
    records
    |> Enum.map_reduce(nil, &do_assign_last_min/2)
    |> elem(0)
  end

  defp do_assign_last_min(record, last_min) do
    {%{record | last_min: last_min}, record.min}
  end

  defp most_asleep_guard(guards) do
    Enum.max_by(guards, &Enum.sum(Map.values(elem(&1, 1))))
  end

  def most_asleep_minute({guard_id, minutes}) do
    {minute, _} = Enum.max_by(minutes, &elem(&1, 1))

    guard_id * minute
  end
end
