# HPCP-Key-Finder
Repository for my MUMT 605 final project

Full source code available!

The algorithm for extracting HPCP from audio signals is implemented in `show_hpcp.m`, which reads a single audio file, computes the instantaneous HPCP for every frame and then generates a plot of the global HPCP vector. This part of the algorithm is functionized in `get_hpcp.m`.

The key profiles used in key estimation can be plotted with `show_profile.m`, where the 12 discrete values of both major and minor key profiles are linearly interpolated to get all 36 key profile values. This part is functionized in `get_profile.m`. These two scripts both call `interp_profile.m`, which is a function for linear interpolation.

To generate a key estimation for one single audio excerpt, run `show_single.m`. This script is dependent on the functions `get_profile.m` and `get_hpcp.m`. It generates a plot of the correlation values with all 24 key profiles. The highest correlation value is circled in red. The label corresponding to the highest correlation value gives the estimated key.

The key estimation process is functionized in `estm_key.m`. It makes use of `get_hpcp.m` and `get_profile.m`, and calculates a correlation value for each of the 24 key profile vectors. The highest correlation value (tonalness) and its corresponding label are returned.

Putting it all together, the experiment on the test dataset is performed by running `main.m`. It loops through all audio files in a directory and writes the key estimation result, including the file names, estimated keys, and tonalness values, into a text file.

Unfortunately, I cannot provide the dataset here.
