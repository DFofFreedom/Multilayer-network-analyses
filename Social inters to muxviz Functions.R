library(tidyverse)
library(tnet)
library(sna)
library(here) # for file paths. The default directory is the root project folder.

#download interaction date from FigShare
download.file("https://ndownloader.figshare.com/files/21743832", "adult_inters_raw.csv")
adult_inters_raw <- read.csv("adult_inters_raw.csv", header=T)

#Start shaping data into useful format
adult_inters = adult_inters_raw %>% 
  mutate(node1 = factor(paste0(adult_inters_raw$Spider.1,"_",adult_inters_raw$Colony)),
         node2 = factor(paste0(adult_inters_raw$Spider.2,"_",adult_inters_raw$Colony)),
         layer1  = as.numeric(factor(paste0(adult_inters_raw$Week,"_", adult_inters_raw$Assay.Type))),
         layer2  = layer1,
         weight = 1)
head(adult_inters)
summary(adult_inters)

plot(with(adult_inters, tapply(node1, layer1, length)) ~ c(1:19),
     type="b", pch=16, frame=F, xlim=c(0,20), ylim=c(150,350),
     ylab="Number of associations", xlab="Time point",main="")

#Code to create a list of multilayer edgelists####

adult_inters_col = adult_inters %>%
  select(node1, layer1, node2, layer2, weight, colony=Colony) %>% 
  group_split(colony) #creates a list where each element is a colony

#So now we have adult_inters_col, which is a list of 24 edgelists, one per colony

#Edgelists are not symmetrical, so need to copy data and then swap node1 and node2

#function to symmetrise each multilayer in a list of multilayer networks
#assumes data is already in muxViz friendly format (as created above), and symmetrises within the variable "layer1"
symmetrise_ML = function(edgelist){
  temp_sym_edges2 = setNames(data.frame(matrix(ncol = ncol(edgelist), nrow = 0)), names(edgelist))
  for (i in 1:length(unique(edgelist$layer1))) {
    temp_edges = edgelist[edgelist$layer1 == unique(edgelist$layer1)[i],] #need to do the symmetrising per layer
    temp_opp_edges = temp_edges
    temp_opp_edges[,c("node1", "node2")] = temp_edges[,c("node2", "node1")] #adds add with inter IDs swapped
    temp_sym_edges = rbind(temp_edges, temp_opp_edges) #sticks the 2 sets of edges together
    temp_sym_edges2 = rbind(temp_sym_edges2,temp_sym_edges) #adds each layer to the already completed ones
  }
  ; temp_sym_edges2
}

adult_inters_sym = lapply(adult_inters_col, symmetrise_ML) #this is now a list where each element is twice as long as it was for "adult_inters_col"

#Next add in self-edges, connecting an individual to itself in consecutive layers
#These need to add in symmetrical format, so including 1-2 and 2-1, etc. 
#not symmetrising in above code as these edges are not within layers
self_edges = expand.grid(as.character(unique(adult_inters$node1)), 1:18) #create all possible combination of indiv ID and layer, aside from layer 19, as the 18-19 edge is created via layer 18.
colnames(self_edges) = c("node1", "layer1")

self_edges = self_edges %>%
  mutate(node2 = node1, layer2 = layer1+1, weight = 1) %>% #create self edge to the next layer
  separate(node1, into = c("NA", "colony"), remove=FALSE, sep="_", convert=T) %>% #add colony ID back in
  select(node1, layer1, node2, layer2, weight, colony)

self_edges2 = self_edges %>% mutate(layer1 = layer1+1, layer2 = layer2-1) #create other half of symmetrical set of edges

self_edges_all = self_edges %>% full_join(self_edges2) %>% #stick together
  group_split(colony) #turn into a list by colony to match format of rest of the data.

#combine with symmetrical edgelist

adult_inters_all = lapply(seq_along(adult_inters_sym),
                          function(x) rbind(adult_inters_sym[[x]], self_edges_all[[x]]))


#If we're staying in R, muxViz needs each edgelist to number the spiders from 1-number of spiders

labels_to_muxviz = function(edgelist){
  
  edgelist$node1 = droplevels(edgelist$node1)
  edgelist$node2 = droplevels(edgelist$node2)
  
  levels(edgelist$node1) = 1:length(levels(edgelist$node1))
  levels(edgelist$node2) = 1:length(levels(edgelist$node2))
  
  edgelist$node1 = as.numeric(edgelist$node1)
  edgelist$node2 = as.numeric(edgelist$node2)
  ; edgelist
}

#apply function over list
adult_inters_mx = lapply(adult_inters_all, labels_to_muxviz)
#this is the final edgelist to use in the analysis code.
save(adult_inters_mx, adult_inters, adult_inters_all, file="adult_inters_mx.RData")


#Creating data for muxViz export####

#need to export each element of list of edgelists with a unique file name
write_edgelistmany = function(edgelist){
  write.table(edgelist[,1:5], file = paste0("edgelist_",unique(edgelist$colony), ".txt"), 
              row.names=FALSE, col.names=FALSE)
}

#apply over list
lapply(adult_inters_mx, write_edgelistmany) #prints a null for each colony, but its fine

#create file describing layers. required by muxViz I believe
#This seems stupid as the layerIDs and layerLabels are the same, so perhaps not necessary?
#now a function to work per edgelist in case they differ in the number of layers, or we change the number of layers in future
write_layerlistmany = function(edgelist){
  write.table(rbind(c('layerID','layerLabel'),
                    cbind(1:length(unique(edgelist$layer1)),
                          1:length(unique(edgelist$layer1)))),
              file = paste0("layerlist_",unique(edgelist$colony), ".txt"),
              row.names=FALSE, col.names=FALSE)
}
lapply(adult_inters_mx, write_layerlistmany)#prints a null for each colony, but its fine

#same for a file describing the nodes, need to account for some colonies having 11 spiders 
#as before is this necessary?

write_nodelistmany = function(edgelist){
  write.table(rbind(c('nodeID','nodeLabel'),
                    cbind(1:length(unique(edgelist$node1)),
                          1:length(unique(edgelist$node1)))),
              file = paste0("nodelist_",unique(edgelist$colony), ".txt"),
              row.names=FALSE, col.names=FALSE)
}
lapply(adult_inters_mx, write_nodelistmany) #prints a null for each colony, but its fine

#then write unique config file for each colony, with ";" separator between file paths
write_configmany = function(edgelist){
  write.table(paste0(".../ML nets/edgelist2_",unique(edgelist$colony),".txt", #need to replace "..." with what ever the path for the folder containing all this analysis is
                     ";.../ML nets/layerlist_",unique(edgelist$colony),".txt",
                     ";.../ML nets/nodelist_",unique(edgelist$colony),".txt"), 
              file = paste0("config2_",unique(edgelist$colony), ".txt"), #note the "2" here refers to the edgelist with node-node interlayer edges
              quote=F, row.names=FALSE, col.names=FALSE)
}
lapply(adult_inters_mx, write_configmany)

####END####

