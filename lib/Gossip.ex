defmodule GossipActor do
  import ActorCommons

  def start_link(node_id, neighbors) do
    GenServer.start_link(__MODULE__, [node_id, neighbors], name: via_tuple(node_id))
  end

  def init([node_id, neighbors]) do
    receive do
      :gossip ->
        gossiping_task = Task.start(fn -> start_gossiping(node_id, neighbors) end)

        listen(1, gossiping_task)
    end

    {:ok, node_id}
  end

  def listen(count, gossiping_task) when count < 10 do
    receive do
      :gossip -> listen(count + 1, gossiping_task)
    end
  end

  def listen(count, gossiping_task) when count >= 10 do
    shutdown(gossiping_task)
  end

  def start_gossiping(node_id, neighbors) do
    Enum.random(neighbors) |> getPid() |> send_gossip

    Process.sleep(100)
    start_gossiping(node_id, neighbors)
  end

  defp send_gossip(pid) do
    if pid != nil do
      send(pid, :gossip)
    end
  end
end


defmodule Gossip do
  import NeighborFactory

  def start(numNodes, topology) do
    initialize_actors(numNodes, topology)

    start_time = System.system_time(:millisecond)
    AlgoCommons.initiate_process(numNodes, :gossip)
    time_diff = System.system_time(:millisecond) - start_time
    IO.puts("Time taken to achieve convergence: #{time_diff} milliseconds")
  end

  def initialize_actors(numNodes, topology) do
    numNodes = correctNumNodesForGrids(numNodes, topology)
    range = 1..numNodes
    random2dGrid = Enum.shuffle(range) |> Enum.with_index(1)

    for i <- range do
      spawn(fn -> GossipActor.start_link(i, getNeighbor(i, numNodes, topology, random2dGrid)) end)
      |> Process.monitor()
    end
  end
end
