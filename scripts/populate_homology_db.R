## Populate homology database using curated list of WPIDs
## e.g., https://docs.google.com/spreadsheets/d/1DHX_FbSwmeTxOXp8ar5BmGKQtOSYriUTtzYajjAlg8c/edit#gid=632216275
## exported as starter_list.csv

library(rWikiPathways)
library(tidyverse)

wpid.table <- read.table("starter_list.csv", header = T, sep = ",", stringsAsFactors = F)

lapply(wpid.table$wpid, function(p){
  dir.create(file.path("pathways",p), showWarnings = FALSE)
  gpml <- rWikiPathways::getPathway(p)
  write(gpml[[1]], file=file.path("pathways",p,paste(p,"gpml",sep = ".")))
})

org.lists <- wpid.table %>%
  group_by(organism) %>%
  summarise(wpid = paste(wpid, collapse = ","))

lapply(org.lists$organism, function(o){
  wpid.s <- str_split(org.lists[which(org.lists$organism == o),2], ",")[[1]]
  write(paste(wpid.s, collapse = "\n"), file=file.path("organisms",paste(o,"txt",sep = ".")))
})
