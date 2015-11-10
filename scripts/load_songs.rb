    # add_column :songs, :meter_name, :string
    # add_column :songs, :meter_count, :string
    # add_column :songs, :song_text, :text
    # add_column :songs, :composer_first_name, :string
    # add_column :songs, :composer_last_name, :string
    # add_column :songs, :composition_date, :string
    # add_column :songs, :poet_first_name, :string
    # add_column :songs, :post_last_name, :string'

require 'csv'

# headers = ['PageNum','Title','TitleOrdinal','MeterName','MeterCount','SongText','Comments','Comp1First','Comp1Last','Comp1Date','Comp2First','Comp2Last','Comp2Date','CompAlternateEntry','CompBookTitle','CompBookTitleAlternateEntry','Poet1First','Poet1Last','Poet1Date','Poet2First','Poet2Last','Poet2Date','PoetAlternateEntry','PoetBookTitle','PoetBookTitleAlternateEntry']

# This is what a row passed into the block looks like. (using p row)
# <CSV::Row "PageNum":"571" "Title":"Penitence" "TitleOrdinal":"" "MeterName":"11s,8s Double" "MeterCount":"11,8,11,8,11,8,11,8" "SongText":"Oh, why should I wander a stranger from Thee,/Or cry in the desert for bread?/My foes will rejoice all my sorrows to see,/And smile at the tears I have shed./Ye daughters of Zion, declare, have you seen/The star that on Israel shone?/Say, if in your tents my beloved has been,/And where with His flocks He has gone.//Oh Thou, in whose presence my soul takes delight/On whom in affliction I call;/My comfort by day and my song in the night/My hope, my salvation, my all./Where dost Thou at noontime reside with Thy sheep/To feed on the pastures of love?/Say why in the valley of death should I weep,/Or lonely the wilderness rove?" "Comments":"" "Comp1First":"Raymond C." "Comp1Last":"Hamrick" "Comp1Date":"1966" "Comp2First":"" "Comp2Last":"" "Comp2Date":"" "CompAlternateEntry":"" "CompBookTitle":"" "CompBookTitleAlternateEntry":"" "Poet1First":"Joseph" "Poet1Last":"Swain" "Poet1Date":"" "Poet2First":"" "Poet2Last":"" "Poet2Date":"" "PoetAlternateEntry":"" "PoetBookTitle":"" "PoetBookTitleAlternateEntry":"">
Call.delete_all
Song.delete_all

Book.find_or_create_by(name:"1991 Sacred Harp")
book = Book.find_by(name: "1991 Sacred Harp")
p book

CSV.foreach "data/SongData_Denson_1991.txt", {headers: true, encoding: "MacRoman:UTF-8"} do |row|
   Song.find_or_create_by!(number: row["PageNum"], book_id: book[:id], name: row["Title"], meter_name: row["MeterName"], meter_count: row["MeterCount"], song_text: row["SongText"], composer_first_name: row["Comp1First"], composer_last_name: row["Comp1Last"], composition_date: row["Comp1Date"], poet_first_name: row["Poet1First"], post_last_name: row["Poet1Last"])
end

