defmodule Project2 do
  def main(args \\ [])
  [numNodes, topology, algo] = System.argv()
  nodes=String.to_integer(numNodes)
  Proj2.main(nodes, topology, algo)
  end
end
