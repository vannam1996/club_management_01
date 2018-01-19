class AddEventIdToAlbums < ActiveRecord::Migration[5.0]
  def change
    add_reference :albums, :event, index: true
  end
end
