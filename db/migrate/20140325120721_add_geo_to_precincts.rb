class AddGeoToPrecincts < ActiveRecord::Migration
  def change
    # execute "create extension postgis;"
    # execute "create extension postgis_topology;"
    #
    add_column :precincts, :geo, 'GEOMETRY(MultiPolygon, 4326)'
  end
end
