class CreateRawLegals < ActiveRecord::Migration
  def change
    create_table :raw_legals, :id => false do |t|
			t.string :folio, :null => false
			t.string :line_number
			t.string :description
			
      #t.timestamps
    end

    add_index :raw_legals, :folio
  end
end
