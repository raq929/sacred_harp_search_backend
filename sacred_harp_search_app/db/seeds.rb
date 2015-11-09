# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
Song.delete_all
Book.delete_all
Call.delete_all
Caller.delete_all
Singing.delete_all

#Create book
sh = Book.create!(name:'1991 Sacred Harp')
puts "Create one book"

#create songs
hall =Song.create!(number:'146', name:'Hallelujah')
mess = Song.create!(number:'131t', name: 'Messiah')
afri = Song.create!(number: '178', name: 'Africa')
puts "Creates 3 songs"

#put songs in book
sh.songs << hall
sh.songs << mess
sh.songs << afri

#creates callers
r = Caller.create!(name:'Rachel Stevens')
m = Caller.create!(name: 'Myles Dakan')
b = Caller.create!(name: "Ben Sachs-Hamilton")
puts "creates 3 callers"

#creates singings

osc = Singing.create!(name: 'Ohio State Convention', location: 'Dayton, Ohio', date:'2005-02-27')
pvs = Singing.create!(name: 'Pioneer Valley Singing', location: 'Northampton, MA', date:'2011-05-23')
wm = Singing.create!(name: 'Western Mass Convention', location: 'Amherst, MA', date:'2013-08-13')
puts "creates 3 singings"

c1 = Call.create!(song_id: hall.id, caller_id: r.id, singing_id: osc.id)
c2 = Call.create!(song_id: mess.id, caller_id: b.id, singing_id: osc.id)
c3 = Call.create!(song_id: afri.id, caller_id: b.id, singing_id: osc.id)
c4 = Call.create!(song_id: hall.id, caller_id: r.id, singing_id: wm.id)
c5 = Call.create!(song_id: afri.id, caller_id: m.id, singing_id: wm.id)
c6 = Call.create!(song_id: hall.id, caller_id: m.id, singing_id: pvs.id)
puts "creates 6 calls"
