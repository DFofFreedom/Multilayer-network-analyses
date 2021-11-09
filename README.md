# Multilayer-network-analyses


This repository contains various R scripts I have written in order to make, manipulate, analyse, and visualise multilayer networks

The code replies on a few packages, typically dplyr, lubridate, tnet, and sna.

From David's email on 2021-11-08:

"The file “Social inters to muxvix Functions.R” takes the records of cuddling associations Noa sent me/that can be downloaded from GitHub and morphs them into a format you can analyse using muxviz in R. Note as we were working with 24 colonies the code mostly uses functions on lists, where each element of the list is a colony. There are some exceptions and some of it is a bit of a hack, so we might need to go through it some time… The code then also exports the data and other files to use in the muxviz application, I case you were interested in using that. There are various bits where you’ll need to enter the file paths for your system, so the code won’t quite work as is.

The “ML temporal nets CZ code.R” file takes the data as created by the above file and then runs the analyses performed in the paper. To do this it downloads some data from Figshare again. Again some of the coding is a bit janky but hopefully it all still works. If you want to re-do any of it then have a bash but we might need to go through it.

Finally the “muxLib DF.R” is an edit of the Muxviz source file, suggested by Nitika Sharma to get round an issue with infinite numbers. You’ll need to save that it in the muxViz-master folder.

I haven’t re-run this code in a while, and never had anyone else run it, so it is possible it doesn’t quite work (any more). It also refers to the online data only but there is a slight chance there were edits I needed to make to that that I didn’t finish, hence not ever actually uploading to Github… Best you have a go and let me know if it works I reckon."
