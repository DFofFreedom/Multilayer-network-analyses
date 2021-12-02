# Multilayer-network-analyses

This repository contains various R scripts written by David Fisher in order to make, manipulate, analyse, and visualise multilayer networks.

The code in this repository was used for the paper _Using multilayer network analysis to explore the temporal dynamics of collective behavior_, by David N. Fisher and Noa Pinter-Wollman (doi: https://doi.org/10.1093/cz/zoaa050)

The code replies on a few packages, typically dplyr, lubridate, tnet, and sna.
This analysis is an [RStudio Project](https://support.rstudio.com/hc/en-us/articles/200526207-Using-RStudio-Projects), which means that it is self-contained and should be possible to run on any computer. 
In order to maintain package and R versions, this project uses `[renv](https://rstudio.github.io/renv/articles/renv.html)` for package management.

### Code files
The file **"Social inters to muxviz Functions.R"** takes the records of cuddling associations (which can be downloaded from Figshare) and morphs them into a format you can analyse using muxviz in R. Note that as we are working with 24 colonies, the code mostly uses functions on lists, where each element of the list is a colony. The code then also exports the data and other files to use in the muxviz application, in case you're interested in using that. 

The **ML temporal nets CZ code.R** file takes the data as created by **"Social inters to muxviz Functions.R"** and runs the analyses performed in the paper. To do this, it downloads some data from Figshare again. 

**"muxLib DF.R"** is an edited version of the [muxviz source file](https://github.com/manlius/muxViz/blob/master/R/muxLib_annotated.R), suggested by Nitika Sharma to get around an issue with infinite numbers. 

### Data files

If you're viewing this README on GitHub, you'll see that there is a folder called **"data/"** that's empty except for a **.gitkeep** file. This is where your intermediate data products will be saved: i.e. the results of running **"Social inters to muxviz Functions.R"**, as well as the data files loaded in from Figshare in **ML temporal nets CZ code.R**.

### How to run the analysis

**Step 1:** Fork/clone/download the repository.

**Step 2:** Click on the Fisher_PinterWollman_CZ_code.Rproj file. Think of this .Rproj file as a "portal" to access the rest of the scripts. **Do not** open one of the other R scripts directly, as this can cause problems with the file paths. When you open the .Rproj file, it will open a new, clean session of RStudio. Then you can access all the code and data files in the "Files" pane of RStudio to run the rest of the analyses.

**Step 3:** Make sure your package versions match the package versions that were used for this analysis. In the console of RStudio, run the command `renv::restore()`. This will load _locally-stored_ package versions that are kept in this project's **renv/** folder. For more information about how `renv` works, see [this article](https://rstudio.github.io/renv/articles/renv.html). You shouldn't have to do much with `renv` after running this `restore()` command.

**Step 4:** Run the script **"Social inters to muxviz Functions.R"**. This will download the data from Figshare and transform it into the right format, storing the intermediate products in the **data/** folder.

**Step 5:** Run the script **"ML Temporal nets CZ code.R"** to complete the rest of the analysis.

### Contributors

[David N. Fisher](https://evoetholab.com/) and Noa [Pinter-Wollman](https://pinterwollmanlab.eeb.ucla.edu/) are the authors of this study and the code.

[Nitika Sharma](https://www.linkedin.com/in/nitika-sharma-8377a736) contributed tweaks to the muxviz code, as seen in **"muxLib DF.R"**. The muxviz functions were originally developed by De Domenico _et al._ (https://github.com/manlius/muxViz). 

[Kaija Gahm](kaijagahm.netlify.app) tweaked the code format, added a few explanatory comments, and restructured the project with `renv` and RStudio projects to make the analyses reproducible.