#!/usr/bin/env Rscript

# Splits ASV sequences into archaeal and bacterial. Outputs one fasta file for
# each set.
#
# Reads a fasta file (first argument) and a taxonomy tsv file (second argument).

suppressPackageStartupMessages(library(Biostrings))
suppressPackageStartupMessages(library(dplyr))

# Read the fasta file
s <- readDNAStringSet(args[1])
sequences <- data.frame(seq = s[])
sequences$Feature.ID <- names(s)
taxonomy <- read.table(args[2], sep = '\t', header = TRUE)

# Write Archaea
sequences %>%
  semi_join(taxonomy %>% filter(grepl('D_0__Archaea', Taxon)), by = 'Feature.ID') %>%
  transmute(d = sprintf(">%s\n%s", Feature.ID, seq)) %>%
  write.table('archaea.fna', sep = '\t', col.names = FALSE, row.names = FALSE, quote = FALSE)

# Write Bacteria
sequences %>%
  semi_join(taxonomy %>% filter(grepl('D_0__Bacteria', Taxon)), by = 'Feature.ID') %>%
  transmute(d = sprintf(">%s\n%s", Feature.ID, seq)) %>%
  write.table('bacteria.fna', sep = '\t', col.names = FALSE, row.names = FALSE, quote = FALSE)
