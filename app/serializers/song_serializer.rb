class SongSerializer < ActiveModel::Serializer
  has_one :book
  attributes :id, :number, :name

  

  def book_name
    object.book.name
  end
end
