class CreateRawLegals < ActiveRecord::Migration
  def change
    create_table :raw_legals, :id => false do |t|
			t.string :Folio
			t.string :LineNumber
			t.string :Description
			
      #t.timestamps
    end

    add_index :raw_legals, :Folio
  end
end
