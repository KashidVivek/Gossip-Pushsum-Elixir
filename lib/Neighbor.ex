defmodule NeighborFactory do
  def getNeighbor(i, numNodes, topology, random2dGrid) do

    if(topology=="full") do
    	Enum.reject(1..numNodes, fn x -> x == i end)
    else if(topology=="line") do
    	Enum.filter(1..numNodes, fn x -> x == i + 1 || x == i - 1 end)
    else if(topology=="rand2D") do
    	rand2DNeighbor(i, numNodes, random2dGrid)
    else if(topology=="honeycomb") do
      honeyCombNeighbor(i, numNodes)
      #Enum.filter(1..numNodes, fn x -> x == i + 1 || x == i - 6 || x == i + 6 end)
    else if(topology=="honeycombRand") do
      honeyCombNeighborRand(i, numNodes)
    else if(topology=="torus3D") do
      get3DTorusNeighbor(i, numNodes)
    end
    end
    end
    end
    end
    end
  end

  def honeyCombNeighbor(i, numnodes) do
    cond do
          i == 1 ->  [i+6]  
          i == 6 ->  [i+6]
          rem(i,2) == 0 && i<6 && i>1 ->  [i+1,i+6] 
          rem(i,2) == 1 && i<6 && i>1->  [i-1,i+6] 
          rem(i,2) == 1 -> [i-6, i+1, i+6] 
          rem(i,2) == 0 -> [i-6,i-1,i+6] 
          rem(i,2) == 0 && i<numnodes && i>numnodes-5 -> [i+1,i-6] 
          rem(i,2) == 1 && i<numnodes && i>numnodes-5 -> [i-1,i-6] 
          i == numnodes-5 || numnodes-> [i-6]  
        end
  end

  def honeyCombNeighborRand(i, numnodes) do
    cond do
          i == 1 ->  [i+6,:rand.uniform(numnodes)]  
          i == 6 ->  [i+6,:rand.uniform(numnodes)]
          rem(i,2) == 0 && i<6 && i>1 ->  [i+1,i+6,:rand.uniform(numnodes)] 
          rem(i,2) == 1 && i<6 && i>1->  [i-1,i+6,:rand.uniform(numnodes)] 
          rem(i,2) == 1 -> [i-6, i+1, i+6,:rand.uniform(numnodes)] 
          rem(i,2) == 0 -> [i-6,i-1,i+6,:rand.uniform(numnodes)] 
          rem(i,2) == 0 && i<numnodes && i>numnodes-5 -> [i+1,i-6,:rand.uniform(numnodes)] 
          rem(i,2) == 1 && i<numnodes && i>numnodes-5 -> [i-1,i-6,:rand.uniform(numnodes)] 
          i == numnodes-5 || numnodes-> [i-6,:rand.uniform(numnodes)]  
        end
  end

  defp get3DNeighbor(i, numNodes) do
    cubeLength = numNodes |> :math.pow(1 / 3)
    numNodes = :math.pow(cubeLength, 3)

    [
      i - 1,
      i + 1,
      i - cubeLength,
      i + cubeLength,
      i - cubeLength * cubeLength,
      i + cubeLength * cubeLength,
    ]
    |> Enum.filter(fn x -> x > 0 && x <= numNodes end) |> Enum.map(fn x-> trunc(x) end)
  end

  def get3DTorusNeighbor(i,numNodes) do
    rowcnt = round(Float.ceil(:math.pow(numNodes,(1/3))))
    cnt = round(Float.ceil(:math.pow(numNodes,(2/3))))
    p_x = if(i+1 <= numNodes && rem(i,rowcnt) !=0) do i+1 else i-rowcnt+1 end
    n_x = if(i-1 >= 1 && rem(i-1,rowcnt) !=0) do i-1 else i+rowcnt-1 end
    p_y = if(rem(i,cnt) !=0 && cnt-rowcnt >= rem(i,(cnt))) do i + (rowcnt+1)  end
    n_y = if((cnt-rowcnt*(rowcnt-1)) < rem(i-1,(cnt)) + 1) do i-rowcnt+1 end
    p_z = if(i+cnt <= numNodes) do i+cnt else i-cnt*(rowcnt-1) end
    n_z = if(i-cnt>=1) do i-cnt else i+cnt*(rowcnt-1) end
    [
      p_x,
      n_x,
      p_y,
      n_y,
      p_z,
      n_z
    ]
    |> Enum.reject(fn x-> is_nil(x) end)
  end

  def rand2DNeighbor(i, numNodes, random2dGrid) do
    gridLen = numNodes |> :math.sqrt() |> trunc()
    k = (gridLen / 10) |> :math.ceil() |> trunc()

    bottom = Enum.map(1..k, fn x -> i + x * gridLen end) |> Enum.filter(fn x -> x <= numNodes end)
    top = Enum.map(1..k, fn x -> i - x * gridLen end) |> Enum.filter(fn x -> x > 0 end)    

    right =
      if rem(i, gridLen) == 0,
        do: [],
        else: Enum.take_while((i + 1)..(i + k), fn x -> rem(x, gridLen) != 1 end)

    left =
      if rem(i, gridLen) == 1,
        do: [],
        else: Enum.take_while((i - 1)..(i - k), fn x -> rem(x, gridLen) != 0 end)

    neighborIndex = top ++ bottom ++ right ++ left |> Enum.map(fn x -> trunc(x) end)

    Enum.filter(random2dGrid, fn x -> Enum.member?(neighborIndex, elem(x, 1)) end)
    |> Enum.map(fn x -> elem(x, 0) end)
  end

  def correctNumNodesForGrids(numNodes, topology) do
    cond do
      topology=="rand2D" -> :math.sqrt(numNodes) |> :math.ceil() |> :math.pow(2) |> trunc()
      true -> numNodes
    end
  end
end
