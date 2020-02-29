# Set the MadGraph Directory

In part `2a_parton_level` and/or `2b_delphes_level_analysis` in Cell 3, the location of MadGraph is set.
In this webpage it is listed as 
```
mg_dir = '/home/software/MG5_aMC_v2_6_2'
```

As we evolve the tutorial and docker images you may need to update this line to be consistent with the docker container. For example 
```
mg_dir = '/home/software/MG5_aMC_v2_6_7'
```

If you install everything yourself, then you would also need to change this to point to madgraph on your system.
