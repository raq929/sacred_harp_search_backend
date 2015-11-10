class SongSerializer < ActiveModel::Serializer
  attributes :id, :number, :name

  def book_name
    object.book.name
  end
end
