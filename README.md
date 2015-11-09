## Sacred Harp Search Backend
Ruby on Rails backend for Sacred Harp Search App

#A brief description of Sacred Harp Singings
At a Sacred Harp Singing, singers sit in a square. Singers agree upon a book or books that will be sung from at that singing. People who want to lead songs (Callers), get up one by one and call a song, which everyone sings. Singings are generally one or two days. Songs cannot be sung more than once a day.
Minutes are taken by the secretary of the singing, who includes the song's number and the caller's name, and the book if the singing has more than one book. These minutes are then reported back to the Sacred Harp Musical Heritage Association (SHMHA).

# Database

The database contains 6 tables:
*Books
*Songs
*Callers
*Singings
*Calls - join table for books, songs, and callers
*Users

# Data

The data I am using comes from Sacred Harp minutes from 1995-2015, which SHMHA generously granted me access to. They also provided a Ruby script to help me get that data into a useable form.



