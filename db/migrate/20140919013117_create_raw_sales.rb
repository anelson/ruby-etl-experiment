class CreateRawSales < ActiveRecord::Migration
  def change
    create_table :raw_sales, :id => false do |t|
			t.string :Folio
			t.string :Municipality
			t.string :SaleID
			t.string :OR_BK
			t.string :OR_PG
			t.string :TransferCode
			t.string :Grantor
			t.string :Grantee
			t.string :DateOfSale
			t.string :Price
			t.string :VI
			t.string :QU_FLG
			t.string :DORCode
			t.string :SiteAddress
			t.string :StreetNumber
			t.string :StreetPrefix
			t.string :StreetName
			t.string :StreetNumberSuffix
			t.string :StreetSuffix
			t.string :StreetDirection
			t.string :CondoUnit
			t.string :SiteCity
			t.string :SiteZip
			t.string :MailingAddressLine1
			t.string :MailingAddressLine2
			t.string :MailingAddressLine3
			t.string :City
			t.string :State
			t.string :Zip
			t.string :Country
			t.string :SalesCode
			t.string :Owner1
			t.string :Owner2
			t.string :Owner3
			t.string :Zoning
			t.string :SqFtg
			t.string :LotSF
			t.string :Acres
			t.string :Bedrooms
			t.string :Baths
			t.string :HalfBaths
			t.string :LivingUnits
			t.string :Stories
			t.string :NumberOfBuilding
			t.string :YearBuilt
			t.string :EffectiveYearBuilt

      #t.timestamps
    end
  end
end
