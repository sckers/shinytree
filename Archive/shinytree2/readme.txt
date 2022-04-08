# shinytree - R Shiny app for phylogenetic tree generation
Interactively creates phylogenetic trees with different statistical models and tree styles.

## Introduction:
This tool takes an input .fasta file and generates phylogenetic trees.  The user can select the phylogenetic model (UPGMA, Neighbor Joining, Maximum Likelihood, or Maximum Parsimony), tree style (circular, fan, slanted, rectangular), and number of bootstraps.

## Technologies/Dependencies: 
Project was created with:<br>
R 3.6.1<br>
ape 5.4-1<br>
ggplot2 3.3.2<br>
ggtree 1.16.6<br>
ggtree 1.16.6<br>
phangorn 2.5.5<br>
seqinr 3.6-1<br>
shiny 1.5.0<br>
shinycssloaders 1.0.0<br>
shinydashboard 0.7.1<br>

## Use:
To install, extract the zip file in your working directory.  The app can then be called by loading shiny with library(shiny) and executing runApp("shinytree") in RStudio.
While the app is running, the sidebar inputs can be used to change the desired phylogenetic model, number of bootstraps, and tree style.  
Once you have selected a new set of inputs, simply click the "new tree" button to create the new tree.  
Some models (maximum likelihood and maximum parsimony) can take a while to run.  Keep this in mind when selecting your number of bootstraps for these models in particular.
