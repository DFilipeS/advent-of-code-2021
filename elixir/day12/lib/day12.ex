defmodule Day12 do
  @doc """
  Returns the total paths in the graph between the "start" and "end" nodes.

  ## Example
      iex> graph = %{
      ...>   "start" => MapSet.new(["A", "b"]),
      ...>   "A" => MapSet.new(["b", "c", "end"]),
      ...>   "b" => MapSet.new(["A", "d", "end"]),
      ...>   "c" => MapSet.new(["A"]),
      ...>   "d" => MapSet.new(["b"]),
      ...>   "end" => MapSet.new([])
      ...> }
      iex> Day12.total_paths(graph)
      10
      iex> Day12.total_paths(graph, special_rule: true)
      36
  """
  def total_paths(graph, opts \\ []) do
    graph
    |> build_paths("start", Keyword.get(opts, :special_rule, false))
    |> length()
  end

  @doc """
  Returns a list of paths between the given node and "end" nodes in the given graph
  using Depth-first search (https://en.wikipedia.org/wiki/Depth-first_search).

  ## Example
      iex> graph = %{
      ...>   "start" => MapSet.new(["A", "b"]),
      ...>   "A" => MapSet.new(["b", "c", "end"]),
      ...>   "b" => MapSet.new(["A", "d", "end"]),
      ...>   "c" => MapSet.new(["A"]),
      ...>   "d" => MapSet.new(["b"]),
      ...>   "end" => MapSet.new([])
      ...> }
      iex> Day12.build_paths(graph, "start")
      [
        ["start", "b", "end"],
        ["start", "b", "A", "end"],
        ["start", "b", "A", "c", "A", "end"],
        ["start", "A", "end"],
        ["start", "A", "c", "A", "end"],
        ["start", "A", "c", "A", "b", "end"],
        ["start", "A", "c", "A", "b", "A", "end"],
        ["start", "A", "b", "end"],
        ["start", "A", "b", "A", "end"],
        ["start", "A", "b", "A", "c", "A", "end"]
      ]
  """

  def build_paths(
        graph,
        vertex,
        special_rule \\ false,
        context \\ %{
          visited: MapSet.new(),
          current_path: [],
          paths: [],
          small_cave_visited_twice?: false
        }
      )

  def build_paths(_graph, "end", _special_rule, context) do
    [context.current_path ++ ["end"] | context.paths]
  end

  def build_paths(graph, vertex, special_rule, context) do
    cond do
      special_rule and not is_uppercase?(vertex) and MapSet.member?(context.visited, vertex) and
          not context.small_cave_visited_twice? ->
        context = Map.put(context, :small_cave_visited_twice?, true)
        process_vertex(graph, vertex, special_rule, context)

      MapSet.member?(context.visited, vertex) and not is_uppercase?(vertex) ->
        context.paths

      true ->
        process_vertex(graph, vertex, special_rule, context)
    end
  end

  @doc """
  Parses the raw input string and returns a map with the directed graph.

  ## Example
      iex> raw_input = "start-A\\nstart-b\\nA-c\\nA-b\\nb-d\\nA-end\\nb-end\\n"
      iex> Day12.parse_input(raw_input)
      %{
        "start" => MapSet.new(["A", "b"]),
        "A" => MapSet.new(["b", "c", "end"]),
        "b" => MapSet.new(["A", "d", "end"]),
        "c" => MapSet.new(["A"]),
        "d" => MapSet.new(["b"]),
        "end" => MapSet.new([])
      }
  """
  def parse_input(raw_input) do
    raw_input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{"start" => MapSet.new(), "end" => MapSet.new()}, fn line, acc ->
      [from, to] = String.split(line, "-")

      acc
      |> add_edge_to_graph(from, to)
      |> add_edge_to_graph(to, from)
    end)
  end

  defp add_edge_to_graph(graph, _from, "start"), do: graph
  defp add_edge_to_graph(graph, "end", _to), do: graph

  defp add_edge_to_graph(graph, from, to) do
    Map.update(graph, from, MapSet.new([to]), &MapSet.put(&1, to))
  end

  defp is_uppercase?(value) do
    String.upcase(value) == value
  end

  defp process_vertex(graph, vertex, special_rule, context) do
    context = Map.update!(context, :visited, &MapSet.put(&1, vertex))

    graph
    |> Map.get(vertex)
    |> Enum.reduce(context.paths, fn edge, acc ->
      edge_context =
        context
        |> Map.put(:current_path, context.current_path ++ [vertex])
        |> Map.put(:paths, acc)

      build_paths(graph, edge, special_rule, edge_context)
    end)
  end
end
