defmodule Project2 do
  def main(args) do
  [numNodes, topology, algo] = [Enum.at(args,0),Enum.at(args,1),Enum.at(args,2)] 
  nodes=String.to_integer(numNodes)
  Proj2.main(nodes, topology, algo)
  end
end
