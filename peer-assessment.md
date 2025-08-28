#### Automate
##Running the entire analysis requires rendering one Quarto document
Not met yet, but you're close it seems to me you are just missing the package call. AKA you just need library(). 

##Analysis runs without errors
Met as of now! I'm able to run through all your lines of code after going into the tidyverse, here, and janitor libraries

##Analysis produces the expected output
Not met. There's no graph as of yet but you have the skeleton for it in your spaghetti!

## Data import/cleaning is handled in its own script
Not met. Currently its in the paper qmd and apparently they want it in its own script *sigh*.

#### Orgainize

##Raw data is contained in its own folder
Met! It's all in data folder!

## Intermediate outputs are created and saved in a separate folder from raw data 
Met! Looks like your'e not touching that data folder at all which is good

##At least one piece of functionality has been refactored into a function in its own file
Not quite met. I see you have two functions in your R folder which is great, however it looks like you still have to refactor possibly. Let me know if im wrong on this one because I very well could be.

#### Document

##The repo has a readme that explains where to find data, analysis, supporting code, and outputs. 
Not met. I think they're looking for a table of contents of sorts. For mine I used a bulleted list to explain where everything lives. 

## The readme includes a flowchart and text explaining how the analysis works. 
Not met yet, however i can see you have the skeleton ready to have something inputted into it! I really dont know why they want a flow chart but that is needed as well!

## The code is appropriately commented 
Met! I really like your in-line comments. If you wanted to go a bit more in depth on what you're doing this could be one you could exceed. 

##Variable and function names are descriptive and follow a consistent naming convention
I LOVE your names. Very good and clear. 

####Scale

##Running the environment initialization script installs all required packages
Not met. I dont know how they want you to do this but i did mine with the {pacman} package which basically is like install and load if the packages are already installed

##Analysis script runs without errors 
skip 



