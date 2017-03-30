This is an R package to interact with Public Health England's [Fingertips](http://fingertips.phe.org.uk/) data tool. 
This can be used to load data from the Fingertips API into R for further manipulation. 

# Installation

## From zip
Download this repository from GitHub and either build from source or do:

	source <- devtools:::source_pkg("C:/path/to/fingertips-master")
	install(source)

## With devtools
	devtools::install_github("username/fingertips")
	
# Use
Please see the vignette for information on use.
	vignette("lifeExpectancy")