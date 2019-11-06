defmodule ActorCommons do
  def via_tuple(node_id), do: {:via, Registry, {:registry, node_id}}

  def getPid(node_id) do
    case Registry.lookup(:registry, node_id) do
      [{pid, _}] -> pid
      [] -> nil
    end
  end

  def shutdown(pid) do
    send(:global.whereis_name(:convergence_task_pid), {:converged, self()})
    Task.shutdown(pid, :kill)
  end
end

defmodule AlgoCommons do
  def initiate_process(numNodes, msg) do
    convergence_task = Task.async(fn -> listenConvergence(numNodes) end)
    :global.register_name(:convergence_task_pid, convergence_task.pid)
    start_process_on_random_node(numNodes, msg)
    Task.await(convergence_task, :infinity)
  end

  def listenConvergence(numNodes) do
    if(numNodes > 0) do
      receive do
        {:converged, pid} ->
          listenConvergence(numNodes - 1)
      after
        1000 ->
          listenConvergence(numNodes - 1)
      end
    end
  end

  def start_process_on_random_node(numNodes, msg) do
    node_pid = numNodes |> :rand.uniform() |> ActorCommons.getPid()

    if node_pid != nil do
      send(node_pid, msg)
    else
      start_process_on_random_node(numNodes, msg)
    end
  end
end

