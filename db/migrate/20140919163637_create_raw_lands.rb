class CreateRawLands < ActiveRecord::Migration
  def change
    create_table :raw_lands, :id => false do |t|
			t.string :folio, :null => false
			t.string :district
			t.string :use_code
			t.string :line_number
			t.string :zone
			t.string :front
			t.string :depth
			t.string :units
			t.string :type
			t.string :depth_factor
			t.string :depth_table
			t.string :influence_code
			
      #t.timestamps
    end

    add_index :raw_lands, :folio
  end
end
