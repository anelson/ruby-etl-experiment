class CreateParcelTaxRolls < ActiveRecord::Migration
  def change
    create_table :parcel_tax_rolls do |t|
    	t.integer :parcel_id, :null => false
    	t.string :folio, :null => false
			t.integer :year, :null => false
			t.decimal :land_value
			t.decimal :building_value
			t.decimal :extra_feature_value
			t.decimal :total_value
			t.decimal :homestead_ex_value
			t.decimal :county_second_homestead_ex_value
			t.decimal :city_second_homestead_ex_value
			t.decimal :window_ex_value
			t.decimal :county_other_ex_value
			t.decimal :city_other_ex_value
			t.decimal :disability_ex_value
			t.decimal :county_senior_ex_value
			t.decimal :city_senior_ex_value
			t.decimal :blind_ex_value
			t.decimal :assessed_value
			t.decimal :county_exemption_value
			t.decimal :county_taxable_value
			t.decimal :city_exemption_value
			t.decimal :city_taxable_value
			t.decimal :regional_exemption_value
			t.decimal :regional_taxable_value
			t.decimal :school_exemption_value
			t.decimal :school_taxable_value

			t.string :rowhash

      t.timestamps
    end

    add_index :parcel_tax_rolls, [:folio, :year], :unique => true

    add_index :parcel_tax_rolls, [:folio, :year, :rowhash], :unique=>true

    add_foreign_key :parcel_tax_rolls, :parcels, dependent: :delete
  end
end
