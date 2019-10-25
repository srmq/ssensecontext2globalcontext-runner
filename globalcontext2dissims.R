library(Matrix)

inputFile <- Sys.getenv("R_CONTEXT_INPUT")
outputFile <- Sys.getenv("R_DISSIMS_OUTPUT")

con <- file(inputFile, "r")
firstLine <- readLines(con,n=1)
close(con)

# trim beginning
firstLine <- sub("^\\s+", "", firstLine)

# trim end
firstLine <- sub("\\s+$", "", firstLine)

# string array. [1]: embed size; [2]: num docs; [3]: # dataset
headerInfo <- unlist(strsplit(firstLine, "\\s+"))
rm(firstLine)
nfeat <- headerInfo[1]
ndocs <- headerInfo[2]
rm(headerInfo)

featureData <- read.table(inputFile, header=FALSE, colClasses=c("integer", "integer", "numeric"), col.names=c("row", "col", "val"), skip=1)

featureDataMatrix <- sparseMatrix(i=featureData$row, j=featureData$col, x=featureData$val, dims=c(nfeat, ndocs))

rm(featureData)

X <- t(scale(t(featureDataMatrix)))

rm(featureDataMatrix)

rowSub <- apply(X, 1, function(row) all(!is.nan(row)))
X <- X[rowSub,]

rm(rowSub)

nfeat <- nrow(X)

distM <- dist(t(X), diag = TRUE)

rm(X)

distAsMatrix <- as.matrix(distM)

rm(distM)

distAsMatrix <- distAsMatrix/max(distAsMatrix)
DissimsExport <- as(distAsMatrix, "sparseMatrix")

rm(distAsMatrix)

writeMM(DissimsExport, file=outputFile)

rm(DissimsExport)
