# Sacred Harp Search Backend
Ruby on Rails backend for Sacred Harp Search App
* [Front end repository](https://github.com/raq929/sacred_harp_search_frontend)
* [Wireframes and user stories](https://github.com/raq929/sacred_harp_search_frontend/tree/master/images/planning)
* [Deploted site](http://raq929.github.io/sacred_harp_search_frontend)
* [Deployed backend](https://mighty-shelf-9974.herokuapp.com/)

##A brief description of Sacred Harp Singings
At a Sacred Harp Singing, singers sit in a square. Singers agree upon a book or books that will be sung from at that singing. People who want to lead songs (Callers), get up one by one and call a song, which everyone sings. Singings are generally one or two days. Songs cannot be sung more than once a day.
Minutes are taken by the secretary of the singing, who includes the song's number and the caller's name, and the book if the singing has more than one book. These minutes are then reported back to the Sacred Harp Musical Heritage Association (SHMHA).

## Database

The database contains 6 tables:
* Books
* Songs
* Callers
* Singings
* Calls - join table for books, songs, and callers
* Users - not attached to other tables

![ERD diagram](https://s3.amazonaws.com/sacredharpsearch/shs_ERD.png)

#Planning
I wanted to be very clear about what the data structure of my site would be before I started building the api. I think that making sure this planning was solid and running it by several people before getting started probably saved me a lot of time overall.

## Data

The data I am using comes from Sacred Harp minutes from 1995-2015, which SHMHA generously granted me access to. They also provided a Ruby script (parse_singingers.rb) to help me get that data into a useable form.

Getting a handle on the data was one of the more difficult aspects of this project, because it was 'dirty' data. Songs calls in the data were marked up to reflect whether they had been original, corrected, ambiguous, or erroneous, and I had to make decisions about how to store that data in my database. Dates are as strings rather than as dates, and names are not separated into title, first name, surname, and suffix, but are jsut one string. So I had to make decisions about what to do with the data. Due to time constraints, I mostly left it as I got it, except for removing the markup on the songs after using it.
The other data issue that I have not yet dealt with is that of multiple names. Because the minutes are written by the secretary at each singing, Ben Sachs-Hamilton might be in the database as "Ben Sachs-Hamilton", "Ben Sachs Hamilton", "Benjamin Sachs-Hamilton", etc. I want to eventually have a table with all the possible spellings, and have those refer to a 'preferred spelling' table, which has one name for each person. However, determining which names were original and which were duplicates was beyond the scope of this project.

## Creating singings
One of the features of this project is that admins can upload minutes (in the formats approved by parent organizations), and they will load into the database. This involved parsing multiple forms of data (csv, tab separated values) and creating new records in the database.

##What I learned
- How to use CSV files and how to parse them (from a file, or from a string).
- How controllers work
- Basics of serializers (I want to know more about them!)
- Loading data: I ran into a lot of issues loading data, due sometimes to validations, and typos, and not understanding how to enter data correctly.
- Active Record Objects: I learned a lot about how they work.

## Things I'd like to add
- more comprehensive minutes parser - able to interperet the minutes format and interpret it
- serializers: I kind of wrote my own for this project, because I didn't fully understand what they are capable of. I'd like to learn more about them and use them more.
- Searching: I'd like to be able to search the database for partial strings and return options.
- debug the function for parsing Denson book minutes








