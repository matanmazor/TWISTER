# TWISTER

A TWISTER experiment is comprised of four experimental runs of equal duration: A1, B1, A2 and B2. The experiment is created in two steps. First, run A1 is formed by randomly dispersing a fixed number of events along a temporal interval of a predefined duration. This step is executed separately for each participant. Second, the three remaining runs are created by taking run A1 as a reference and twisting the events along the first dimension (B1), the second dimension (A2), or both (B2). The resulting four runs can be used in random order. 

![figure](/figure1Cropped.png)

Consequently, voxels can be embedded in a two dimensional space according to the temporal consistency along the two twisted stimulus dimensions, as reflected in the correlation coefficients between time-series. A brain region whose time-series during run A1 is more consistent (i.e., has higher correlation) with its activation pattern during run A2 than during run B1 is more sensitive to the first dimension (A vs. B) than to the second dimension (1 vs. 2). Similarly, a brain region whose time-series during run B2 is more consistent with its activation pattern during run A2 than during run B1 is more sensitive to the second dimension (1 vs. 2) and less to the first (A vs. B).

This repository includes the analysis tools for comparing the similarity between voxel time-courses in different TWISTER runs.
