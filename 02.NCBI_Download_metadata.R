
# Loading libraries  ----------------------------------------------
package_to_load <- c("tidyverse","R.utils","xml2","httr")
package_installed <- package_to_load %in% installed.packages()
if(length(package_to_load[!package_installed]) > 0) {install.packages(.packages[!.inst]) }
lapply(package_to_load, require, character.only=TRUE)
# Load data from NCBI -----------------------------------------------------
data <- read.table(file = "prokaryotes_filtered.txt", header=TRUE, sep="\t")
Prokaryotes_filtered <- data

urls <- NULL
metadata <- NULL
location <- NULL
source <- NULL
host <- NULL
collection_date <- NULL
strain <- NULL

###	Biosample.Accesion ---- Assembly.Accession		TO SAVE THE METADATA 

for (i in 1:nrow(Prokaryotes_filtered)) {
  urls[i] <- paste("https://www.ncbi.nlm.nih.gov/biosample/",Prokaryotes_filtered$BioSample.Accession[i],"?report=full&format=text", sep = "");
  metadata <- read_file( file = paste("https://www.ncbi.nlm.nih.gov/biosample/",Prokaryotes_filtered$BioSample.Accession[i],"?report=full&format=text", sep = "")) %>% read_lines() %>% .[] %>% str_split(pattern = '=', simplify = T);
   if (sum(str_detect(string = metadata[,1], pattern = "geographic location")) == 1) {
    location[i] <- metadata[str_detect(string = metadata[,1], pattern = "geographic location"),2]} else {location[i] <- "not found"}
  if (sum(str_detect(string = metadata[,1], pattern = "source")) == 1) {
    source[i] <- metadata[str_detect(string = metadata[,1], pattern = "source"),2]} else {source[i] <- "not found"}
  if (sum(str_detect(string = metadata[,1], pattern = "host")) == 1) {
    host[i] <- metadata[str_detect(string = metadata[,1], pattern = "host"),2]} else {host[i] <- "not found"}
  if (sum(str_detect(string = metadata[,1], pattern = "strain")) == 1) {
    strain[i] <- metadata[str_detect(string = metadata[,1], pattern = "strain"),2]} else {strain[i] <- "not found"}
  if (sum(str_detect(string = metadata[,1], pattern = "collection date")) == 1) {
    collection_date[i] <- metadata[str_detect(string = metadata[,1], pattern = "collection date"),2]} else {collection_date[i] <- "not found"}
}  
# If an error is prompt possibly is due to fact that the number of rows between the prokaryotes_filtered and the number os web scrapped is not the same, you can fix the number of Prokaryotes_filtered$BioSample_Accession to the number of rows of location
metadata_file <- data.frame(Biosample = Prokaryotes_filtered$Assembly.Accession,
collection_date = collection_date, 
location = location, 
isolation_source = source, 
host = host, 
strain = strain) 
#Biosample_url = urls)
#, 
#FTP_url = Prokaryotes_filtered$FTP.Path[1:i])  

metadata_file$host[metadata_file$host=="not found"]<-as.factor("unknown")

position<-which(levels(metadata_file$host)=="not found")
levels(metadata_file$host)[position]<- "unknown"



write.table(metadata_file, file="metadata_NCBI.txt", sep="\t", quote=FALSE)





