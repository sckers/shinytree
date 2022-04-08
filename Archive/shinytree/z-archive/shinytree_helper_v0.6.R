# Script providing functions for an R-Shiny server allowing for the customization and visualization
# of phylogenetic trees.  

# Dependencies: ape, phangorn, seqinr, ggtree, ggplot2

# Group project for BIFS 613 9040 Statistical Processes for Biotechnology
# Sarah Kerscher, Benjamin Sparklin, and Aaron Tyler
# 19Sep20

# Import required libraries
library(ape)
library(phangorn)
library(seqinr)
library(ggplot2)
library(ggtree)

tree_style <- "slanted"
bootstraps <- 10
phylo <- "Neighbor Joining"
tree <- "tree_output.tre"
  
tree_build <- function(phylo, bootstraps){
# Takes input from shiny server on phylogenetic method to use,n umber of bootstraps, and tree style
# and returns a phylogenetic tree with parsimony score
  if (phylo == "Neighbor Joining"){
  # Returns NJ tree with desired number of bootstraps
    #creates msa, phylogeny data, and distances for the tree
    input <- "data/Nocardia.fasta"
    msa <- read.dna(input, format="fasta")
    msa_phyDat <- phyDat(msa, type="DNA", levels = NULL)
    dna_dist <- dist.ml(msa, model="F81")
    #constructs the tree with the desired model
    tree <- NJ(dna_dist)
    set.seed(123)
    NJtrees <- bootstrap.phyDat(msa_phyDat, FUN=function(x)NJ(dist.logDet(x)), bs=bootstraps)
    tree_output <- plotBS(tree, NJtrees, "phylogram")
    tree_output <- write.tree(tree_output, file="data/tree_output.tre")
  }
  if (phylo == "UPGMA"){
  # Returns UPGMA tree with desired number of bootstraps
    #creates msa, phylogeny data, and distances for the tree
    input <- "data/Nocardia.fasta"
    msa <- read.dna(input, format="fasta")
    msa_phyDat <- phyDat(msa, type="DNA", levels = NULL)
    dna_dist <- dist.ml(msa, model="F81")
    #constructs the tree with the desired model
    tree <- upgma(dna_dist)
    set.seed(123)
    UPGMAtrees <- bootstrap.phyDat(msa_phyDat, FUN=function(x)NJ(dist.logDet(x)), bs=bootstraps)
    tree_output <- plotBS(tree, UPGMAtrees, "phylogram")
    tree_output <- write.tree(tree_output, file="data/tree_output.tre")
  }
  if (phylo == "Maximum Likelihood"){
  # Returns ML tree with desired number of bootstraps
    #creates msa, phylogeny data, and distances for the tree
    input <- "data/Nocardia.fasta"
    msa <- read.dna(input, format="fasta")
    msa_phyDat <- phyDat(msa, type="DNA", levels = NULL)
    dna_dist <- dist.ml(msa, model="F81")
    #constructs the tree with the desired model
    tree <- NJ(dna_dist)
    fit <- pml(tree, msa_phyDat)
    fit <- optim.pml(fit, rearrangement="NNI")
    set.seed(123)
    bs <- bootstrap.pml(fit, bs=bootstraps, optNni=TRUE)
    tree_output <- plotBS(fit$tree, bs, "phylogram")
    tree_output <- write.tree(tree_output, file="data/tree_output.tre")
  }
  if (phylo == "Maximum Parsimony"){
  # Returns MP tree with desired number of bootstraps
    #creates msa, phylogeny data, and distances for the tree
    input <- "data/Nocardia.fasta"
    msa <- read.dna(input, format="fasta")
    msa_phyDat <- phyDat(msa, type="DNA", levels = NULL)
    dna_dist <- dist.ml(msa, model="F81")
    #constructs the tree with the desired model
    treeMP <- pratchet(msa_phyDat)
    treeMP <- acctran(treeMP, msa_phyDat)
    set.seed(123)
    BStrees <- bootstrap.phyDat(msa_phyDat, pratchet, bs=bootstraps)
    tree_output <- plotBS(treeMP, BStrees, "phylogram")
    tree_output <- write.tree(tree_output, file="data/tree_output.tre")
  }
}

# Create UPGMA tree with proper xlimits.  Valid for tree_style inputs "circular", "fan", "slanted", and "rectangular" 
tree_plot_UPGMA <- function(tree_style, phylo, bootstraps){
  tree <- read.tree("data/tree_output.tre")
    # checks to see if circular or fan style, and angles the tip labels if so
    if (tree_style == "circular" | tree_style == "fan") {
      ggtree(tree, layout=tree_style) +
        ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
        geom_tiplab(aes(angle=angle, size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(NA,0.04)
    } else{
    ggtree(tree, layout=tree_style) +
        ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
          geom_tiplab(aes(size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(NA,0.04)
    }
}

# Create NJ tree with proper xlimits.  Valid for tree_style inputs "circular", "fan", "slanted", and "rectangular" 
tree_plot_NJ <- function(tree_style, phylo, bootstraps){
  tree <- read.tree("data/tree_output.tre")
  # checks to see if circular or fan style, and angles the tip labels if so
  if (tree_style == "circular" | tree_style == "fan") {
    ggtree(tree, layout=tree_style) +
      ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
      geom_tiplab(aes(angle=angle, size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(0,0.03)
  } else{
    ggtree(tree, layout=tree_style) +
      ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
      geom_tiplab(aes(size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(0,0.03)
  }
}

# Create ML tree with proper xlimits.  Valid for tree_style inputs "circular", "fan", "slanted", and "rectangular" 
tree_plot_ML <- function(tree_style, phylo, bootstraps){
  tree <- read.tree("data/tree_output.tre")
  # checks to see if circular or fan style, and angles the tip labels if so
  if (tree_style == "circular" | tree_style == "fan") {
    ggtree(tree, layout=tree_style) +
      ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
      geom_tiplab(aes(angle=angle, size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(0,0.06)
  } else{
    ggtree(tree, layout=tree_style) +
      ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
      geom_tiplab(aes(size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(0,0.08)
  }
}

# Create MP tree with proper xlimits.  Valid for tree_style inputs "circular", "fan", "slanted", and "rectangular" 
tree_plot_MP <- function(tree_style, phylo, bootstraps){
  tree <- read.tree("data/tree_output.tre")
  # checks to see if circular or fan style, and angles the tip labels if so
  if (tree_style == "circular" | tree_style == "fan") {
    ggtree(tree, layout=tree_style) +
      ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
      geom_tiplab(aes(angle=angle, size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(0,110)
  } else{
    ggtree(tree, layout=tree_style) +
      ggtitle(paste("Nocardia Phylogenetic Tree Using", phylo, "With", bootstraps, "Bootstraps")) +
      geom_tiplab(aes(size=1)) + theme(plot.title = element_text(hjust = 0.5)) + xlim(0,170)
  }
}
