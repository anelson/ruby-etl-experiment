class CreateRawBuildingDetails < ActiveRecord::Migration
  def change
    create_table :raw_building_details, :id => false do |t|
			t.string :folio, :null => false
			t.string :building_number
			t.string :line_number
			t.string :type
			t.string :code
			t.string :percent
			t.string :points
			t.string :sf_adj
			t.string :element
			t.string :description

      #t.timestamps
    end

    add_index :raw_building_details, :folio
  end
end
