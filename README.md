# README

The application is still a work in progress. Currently implemented functionality includes: 
* simple authentication (sign up/sign in)
* searching for people using the TISS API
* adding people to a list of favourites for the currently logged in user
* displaying the list of favourites
* removing entries from the list
* displaying details of a person (found through the search functionality or in the favourites)

Prerequisites:
* Ruby version 3.0.3-1
* Rails version 7.0.1

Running the project:
* as a first step, it may be needed to run the following command from the root of the project to setup the database: "ruby bin/rails db:migrate"
* to actually start the project, run "ruby bin/rails server" from the root of the project
* the project was tested in Chrome developer tools with the iPhone SE resolution 

Further information:
* please find a timesheet for the two group members in the file "timesheet.xlsx", inside the root directory of project