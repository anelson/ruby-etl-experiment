class CreateRawSales < ActiveRecord::Migration
  def change
    create_table :raw_sales, :id => false do |t|
			t.string :folio, :null => false
			t.string :municipality
			t.string :sale_i_d
			t.string :or_bk
			t.string :or_pg
			t.string :transfer_code
			t.string :grantor
			t.string :grantee
			t.string :date_of_sale
			t.string :price
			t.string :vi
			t.string :qu_flg
			t.string :d_o_r_code
			t.string :site_address
			t.string :street_number
			t.string :street_prefix
			t.string :street_name
			t.string :street_number_suffix
			t.string :street_suffix
			t.string :street_direction
			t.string :condo_unit
			t.string :site_city
			t.string :site_zip
			t.string :mailing_address_line1
			t.string :mailing_address_line2
			t.string :mailing_address_line3
			t.string :city
			t.string :state
			t.string :zip
			t.string :country
			t.string :sales_code
			t.string :owner1
			t.string :owner2
			t.string :owner3
			t.string :zoning
			t.string :sq_ftg
			t.string :lot_s_f
			t.string :acres
			t.string :bedrooms
			t.string :baths
			t.string :half_baths
			t.string :living_units
			t.string :stories
			t.string :number_of_building
			t.string :year_built
			t.string :effective_year_built

      #t.timestamps
    end

    add_index :raw_sales, :folio
  end
end
