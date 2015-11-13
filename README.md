# Sacred Harp Search Backend
Ruby on Rails backend for Sacred Harp Search App
[Front end](https://github.com/raq929/sacred_harp_search_frontend)

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

[../shs_ERD.png]

## Data

The data I am using comes from Sacred Harp minutes from 1995-2015, which SHMHA generously granted me access to. They also provided a Ruby script to help me get that data into a useable form.

Getting a handle on the data was one of the more difficult aspects of this project, because it was 'dirty' data. Songs calls in the data were marked up to reflect whether they had been original, corrected, ambiguous, or erroneous, and I had to make decisions about how to store that data in my database.
The other data issue that I have not yet dealt with is that of multiple names. Because the minutes are written by the secretary at each singing, Ben Sachs-Hamilton might be in the database as "Ben Sachs-Hamilton", "Ben Sachs Hamilton", "Benjamin Sachs-Hamilton", etc. I want to eventually have a table with all the possible spellings, and have those refer to a 'preferred spelling' table, which has one name for each person. However, determining which names were original and which were duplicates was beyond the scope of this project.

## Creating singings
One of the features of this project is that admins can upload minutes (in the formats approved by parent organizations), and they will load into the database. This involved parsing multiple forms of data (csv, tab separated values) and creating new records in the database.

## Things I'd like to add
- more comprehensive minutes parser - able to interperet the minutes format and interpret it
- serializers: I kind of wrote my own for this project, because I didn't fully understand what they are capable of. I'd like to learn more about them and use them more.
- Searching: I'd like to be able to search the database for partial strings and return options.








