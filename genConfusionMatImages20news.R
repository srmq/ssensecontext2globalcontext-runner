library(methods)
library(ggplot2)

rTableFile <- Sys.getenv("RTABLE_FILE")
pdfOutFile <- Sys.getenv("RPDFOUT_FILE")

clusterTest <- read.table(rTableFile, header=TRUE)
clusterTest$Cluster <- as.factor(clusterTest$Cluster)
clusterTest$Cluster <- as.ordered(clusterTest$Cluster)
clusterTest$Real <- factor(clusterTest$Real, levels = c("soc.religion.christian", "alt.atheism", "talk.religion.misc", "comp.graphics", "comp.sys.mac.hardware", "comp.sys.ibm.pc.hardware", "comp.windows.x","comp.os.ms-windows.misc", "misc.forsale", "rec.autos","rec.motorcycles","rec.sport.hockey","rec.sport.baseball","sci.crypt","sci.electronics","sci.med","sci.space","talk.politics.guns","talk.politics.mideast","talk.politics.misc"), ordered=TRUE)

pdf(pdfOutFile, height=3.5, width=6)

ggplot(clusterTest, aes(Cluster, Real, colour=Real)) +
      geom_count() +
      scale_size_area() + guides(colour=FALSE) + theme(text = element_text(size=8))

dev.off()
