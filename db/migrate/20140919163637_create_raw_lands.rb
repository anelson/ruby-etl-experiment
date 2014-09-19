class CreateRawLands < ActiveRecord::Migration
  def change
    create_table :raw_lands, :id => false do |t|
			t.string :Folio
			t.string :District
			t.string :UseCode
			t.string :LineNumber
			t.string :Zone
			t.string :Front
			t.string :Depth
			t.string :Units
			t.string :Type
			t.string :DepthFactor
			t.string :DepthTable
			t.string :InfluenceCode
			
      #t.timestamps
    end

    add_index :raw_lands, :Folio
  end
end
