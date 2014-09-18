class CreateRawParcels < ActiveRecord::Migration
  def change
    create_table :raw_parcels do |t|
		  t.string :Folio
			t.string :Municipality
			t.string :Owner1
			t.string :Owner2
			t.string :Owner3
			t.string :MailingAddressLine1
			t.string :MailingAddressLine2
			t.string :MailingAddressLine3
			t.string :City
			t.string :State
			t.string :Zip
			t.string :Country
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
			t.string :DORCode
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
			t.string :MillageCode
			t.string :CurrentYear
			t.string :CurrentLandValue
			t.string :CurrentBuildingValue
			t.string :CurrentExtraFeatureValue
			t.string :CurrentTotalValue
			t.string :CurrentHomesteadExValue
			t.string :CurrentCountySecondHomesteadExValue
			t.string :CurrentCitySecondHomesteadExValue
			t.string :CurrentWindowExValue
			t.string :CurrentCountyOtherExValue
			t.string :CurrentCityOtherExValue
			t.string :CurrentDisabilityExValue
			t.string :CurrentCountySeniorExValue
			t.string :CurrentCitySeniorExValue
			t.string :CurrentBlindExValue
			t.string :CurrentAssessedValue
			t.string :CurrentCountyExemptionValue
			t.string :CurrentCountyTaxableValue
			t.string :CurrentCityExemptionValue
			t.string :CurrentCityTaxableValue
			t.string :CurrentRegionalExemptionValue
			t.string :CurrentRegionalTaxableValue
			t.string :CurrentSchoolExemptionValue
			t.string :CurrentSchoolTaxableValue
			t.string :PriorYear
			t.string :PriorLandValue
			t.string :PriorBuildingValue
			t.string :PriorExtraFeatureValue
			t.string :PriorTotalValue
			t.string :PriorHomesteadExValue
			t.string :PriorCountySecondHomesteadExValue
			t.string :PriorCitySecondHomesteadExValue
			t.string :PriorWindowExValue
			t.string :PriorCountyOtherExValue
			t.string :PriorCityOtherExValue
			t.string :PriorDisabilityExValue
			t.string :PriorCountySeniorExValue
			t.string :PriorCitySeniorExValue
			t.string :PriorBlindExValue
			t.string :PriorAssessedValue
			t.string :PriorCountyExemptionValue
			t.string :PriorCountyTaxableValue
			t.string :PriorCityExemptionValue
			t.string :PriorCityTaxableValue
			t.string :PriorRegionalExemptionValue
			t.string :PriorRegionalTaxableValue
			t.string :PriorSchoolExemptionValue
			t.string :PriorSchoolTaxableValue
			t.string :Prior2Year
			t.string :Prior2LandValue
			t.string :Prior2BuildingValue
			t.string :Prior2ExtraFeatureValue
			t.string :Prior2TotalValue
			t.string :Prior2HomesteadExValue
			t.string :Prior2CountySecondHomesteadExValue
			t.string :Prior2CitySecondHomesteadExValue
			t.string :Prior2WindowExValue
			t.string :Prior2CountyOtherExValue
			t.string :Prior2CityOtherExValue
			t.string :Prior2DisabilityExValue
			t.string :Prior2CountySeniorExValue
			t.string :Prior2CitySeniorExValue
			t.string :Prior2BlindExValue
			t.string :Prior2AssessedValue
			t.string :Prior2CountyExemptionValue
			t.string :Prior2CountyTaxableValue
			t.string :Prior2CityExemptionValue
			t.string :Prior2CityTaxableValue
			t.string :Prior2RegionalExemptionValue
			t.string :Prior2RegionalTaxableValue
			t.string :Prior2SchoolExemptionValue
			t.string :Prior2SchoolTaxableValue

      t.timestamps
    end

    add_index :raw_parcels, :Folio, :unique=>true
  end
end
