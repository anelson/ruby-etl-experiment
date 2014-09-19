class CreateRawBuildingDetails < ActiveRecord::Migration
  def change
    create_table :raw_building_details, :id => false do |t|
			t.string :Folio
			t.string :BuildingNumber
			t.string :LineNumber
			t.string :Type
			t.string :Code
			t.string :Percent
			t.string :Points
			t.string :SF_ADJ
			t.string :Element
			t.string :Description

      #t.timestamps
    end

    add_index :raw_building_details, :Folio
  end
end
