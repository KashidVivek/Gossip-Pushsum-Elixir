defmodule Proj2 do
  def main(numNodes, topology, algo) do
    Registry.start_link(keys: :unique, name: :registry)
    IO.puts ("Running #{algo} on #{numNodes} Nodes and #{topology} Network")
    IO.puts("Please Wait Converging ........")
    if(algo=="gossip") do
    	Gossip.start(numNodes, topology)
    else if(algo=="pushsum") do
    	Pushsum.start(numNodes, topology)
    end
    end
  end
end