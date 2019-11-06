# Gossip Simulator Solution - COP5615 (Fall 2019)

# Group Members-
Vivek Lalasaheb Kashid 
Vibhav Goel 

# Problem-
The goal of this second project is to use Elixir and the actor model to implement gossip simulator and determine the convergence of algorithm using different topologies.

# What is working?  
* All the topologies are working.
* The best topology in terms of least convergence time is random 2D. The maximum number of nodes that converged without any failures: 10000.
* The above mentioned number is bound by constraints imposed by system limitations because the time taken to run is quite low. The system runs 10000 processes at a time with the given implementation in place and considerable sluggishness in the system is observed. If run on a system with better configuration, it should be able to churn more number of nodes.
* The line topology is slowest in gossip.
* Torus topology works mostly like the fully connected topology, but for pushsum it strangely takes a lot of time to converge. We decided to make the grid length optimal by always taking a cube 3D for Torus to extract the least possible time for convergence.

# Steps to run your code-
1) Unzip contents to your desired elixir project folder.
2) Open cmd window from this project location.
3) Use "mix escript.build" in commandline without quotes to compile.
4) Use "escript proj2 <nodes> <topology> <algorithm>" in commandline without quotes to run.
5) The results will include time in milliseconds to converge.

# Please ensure you type the exact same spelling of the topologies and algorithm
Topologies: "full", "line", "rand2D", "torus3D", "honeycomb", "honeycombRand"  
Algorithms: "gossip", "pushsum"

# Largest problem we managed to solve-
The largest network we managed to deal with for each type of topology and algorithm is 5000 nodes.