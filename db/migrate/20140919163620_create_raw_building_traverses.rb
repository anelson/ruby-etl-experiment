class CreateRawBuildingTraverses < ActiveRecord::Migration
  def change
    create_table :raw_building_traverses, :id => false do |t|

			t.string :Folio
			t.string :BuildingNumber
			t.string :ImprovementType
			t.text :Traverse

      #t.timestamps
    end

    add_index :raw_building_traverses, :Folio
  end
end
