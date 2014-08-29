# Surviving R: Getting help
Help.start() 
# General introduction (pdf)
# Google is your friend
# Meetups – R coding dojo
# - http://www.meetup.com/
# - r coding dojo - 

# Let's say you came across the following script
mtcars[1:3,2:4]
colnames(mtcars)
row.names(mtcars)
names(mtcars)
mycars <- mtcars[1:10,] 

# You will no doubt be asking yourself questions like “what is mtcars?”,  “what do the brackets do?” etc.
help(mtcars)

# The Core R codebase comes with some data sets you can play with. We will later look at packages and these too often come with test datasets. To get a list of datasets you currently have available to you run the following command;
data()

# Now back to the script we saw above. 

# To make sense of the square brackets you would type the following;
help('[')
         
# The square brackets are used to extract/replace parts of an object. We will take a look at this shortly.
         
# Similarly you can type help and a name of a function you need to understand. This works more or less like what we saw of the ?function-name form i.e. ?mean.
         
help('mean')
         
# You can also use the help.search(‘searchstring’) function to carry out fuzzy matching of your search string. This searches deeper and returns more results that the help(‘searchstring’ alternative.
         