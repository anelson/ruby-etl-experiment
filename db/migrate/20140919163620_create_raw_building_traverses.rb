class CreateRawBuildingTraverses < ActiveRecord::Migration
  def change
    create_table :raw_building_traverses, :id => false do |t|

			t.string :folio, :null => false
			t.string :building_number
			t.string :improvement_type
			t.text :traverse

      #t.timestamps
    end

    add_index :raw_building_traverses, :folio
  end
end
