#Example of what minutes look like.
# {
#   "Name": "Liberty Church",
#   "Location": "Helicon, Alabama",
#   "Date": "December 4, 1994",
#   "Minutes": "The 46th session of the annual Sacred Harp singing at Liberty Church, in Winston County, was called to order by Billy Williams leading song on page [33b]. Prayer by Kenneth Handcock. Billy Williams then led {72} and leaders were called as follows: Alpha Black [318], [345b]; Corene White {73}, [379]; Stella Pratt {147}, [460]; Aubrey Tyree [358], [298], [434]; L. E. Hannah [147b], [455], [400]; Eron White [37b], [36b], [146]; B. B. Mattox [421] for Unie B. Howard who is ill, [217], [168]; Reedie Powell [200], [300], [269].\nRECESS\nThe class resumed singing with Billy Williams leading [410t]. The class was organized by electing the following officers: Chairman - Billy Williams; Vice Chairman - Ted Godsey; Arranging Committee - Travis Keeton; Secretary - Alpha Black. Leaders: Mae Conwill [270], [75], [99]; Carmon Brothers [101t], [207], {74}, for Ervin Brothers “That Beautiful Land”; Lola Roberson [475], [222]; John Hocutt [321b//321], [33t]; Elmer Conwill {448}.\nLUNCH\nThe class was called back by the Chairman, Billy Williams, leading song on page [127]. Leaders: Margaret Keeton and Bradley Allen [546], [402], [385b]; Josie Hyde [183], [428], [196]; Ester Brown [436], [317b//317]; John Hyde [39b], [63], {68}; Ada Godsey [59], [482], [301]; Elmer Conwill [142], {275}; Amanda Denson [186], [273]; Charley McCoy [280], [306], [198]; Ted Godsey [236], [408]; Blanton Adair [335], [339]; James Denson [224], [211], [358]; Alma Tyree, Viola Tyree, Bertha Wilson, Reedie Powell, James Denson, Amanda Denson, Roy Cleghorn, Blanton Adair, Jerry Parrish, Ruth Parrish, and Aubrey Tyree [358]; Travis Keeton [57], [56t], [225t]. Billy Williams [231], Aubrey Tyree 20b; Charley McCoy [36b]; Billy Williams [290]. The closing prayer was led by Aubrey Tyree.\nChairman - Billy Williams; Vice Chairman - Ted Godsey; Secretary - Alpha Black.",
#   "Year": 1995,
#   "IsDenson": 1,
#   "GoodCt": 62,
#   "ErrCt": 0,
#   "AmbCt": 7,
#   "CorrCt": 2,
#   "ProbCt": 9,
#   "TotalCt": 71,
#   "ProbPercent": 0.126760563380282,
#   "Singers": [
#     {
#       "name": "Alpha Black",
#       "songs": [
#         "[318]",
#         "[345b]"
#       ]
#     },
#     {
#       "name": "Corene White",
#       "songs": [
#         "{73}",
#         "[379]"
#       ]
#     },
#     {
#       "name": "Stella Pratt",
#       "songs": [
#         "{147}",
#         "[460]"
#       ]
#     },
require 'json'

file = File.read("data/Minutes_All.json")

minutes = JSON.parse(file)

minutes.each do |singing|
  Singing.create!(name: singing.Name, location: singing.Location, date: singing.Date)
end


