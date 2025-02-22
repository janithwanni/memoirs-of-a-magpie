word_count<-function(txt_doc){
  con<-file(txt_doc, "r", blocking=FALSE)
  x<-readLines(con)
  #Remove YAML front matter on Rmd
  if(length(grep("---",x))>0){x<-x[-seq(1,max(grep("---",x)))]}
  wrds<-0
  for(line in x){
    #Removes non character and splits
    split_line<-strsplit(gsub("[^[:alnum:] ]", "", line), " +")[[1]]
    #Removes empty string
    split_line<-split_line[split_line!=""]
    wrds<-wrds+length(split_line)
  }
  close(con)
  return(wrds)
}

if (!nzchar(Sys.getenv("QUARTO_PROJECT_RENDER_ALL"))) {
  quit()
}
print(Sys.getenv("QUARTO_PROJECT_INPUT_FILES"))
total_word_count <- Sys.getenv("QUARTO_PROJECT_INPUT_FILES") |>
  strsplit("\n") |> 
  unlist() |> 
  sapply(word_count) |> 
  sum()

saveRDS(total_word_count, "word_count_latest.rds")

writeLines(glue::glue("Number of words put out to the world: {total_word_count}"), "word-count.md")

