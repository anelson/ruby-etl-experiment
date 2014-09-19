# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140919194602) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "parcel_tax_rolls", force: true do |t|
    t.integer  "parcel_id",                        null: false
    t.string   "folio",                            null: false
    t.integer  "year",                             null: false
    t.decimal  "land_value"
    t.decimal  "building_value"
    t.decimal  "extra_feature_value"
    t.decimal  "total_value"
    t.decimal  "homestead_ex_value"
    t.decimal  "county_second_homestead_ex_value"
    t.decimal  "city_second_homestead_ex_value"
    t.decimal  "window_ex_value"
    t.decimal  "county_other_ex_value"
    t.decimal  "city_other_ex_value"
    t.decimal  "disability_ex_value"
    t.decimal  "county_senior_ex_value"
    t.decimal  "city_senior_ex_value"
    t.decimal  "blind_ex_value"
    t.decimal  "assessed_value"
    t.decimal  "county_exemption_value"
    t.decimal  "county_taxable_value"
    t.decimal  "city_exemption_value"
    t.decimal  "city_taxable_value"
    t.decimal  "regional_exemption_value"
    t.decimal  "regional_taxable_value"
    t.decimal  "school_exemption_value"
    t.decimal  "school_taxable_value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parcel_tax_rolls", ["folio", "year"], name: "index_parcel_tax_rolls_on_folio_and_year", unique: true, using: :btree

  create_table "parcels", force: true do |t|
    t.string   "folio",                 null: false
    t.string   "municipality"
    t.string   "owner1"
    t.string   "owner2"
    t.string   "owner3"
    t.string   "mailing_address_line1"
    t.string   "mailing_address_line2"
    t.string   "mailing_address_line3"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.string   "country"
    t.string   "site_address"
    t.string   "street_number"
    t.string   "street_prefix"
    t.string   "street_name"
    t.string   "street_number_suffix"
    t.string   "street_suffix"
    t.string   "street_direction"
    t.string   "condo_unit"
    t.string   "site_city"
    t.string   "site_zip"
    t.integer  "d_o_r_code"
    t.integer  "zoning"
    t.decimal  "sq_ftg"
    t.decimal  "lot_s_f"
    t.decimal  "acres"
    t.decimal  "bedrooms"
    t.decimal  "baths"
    t.integer  "half_baths"
    t.integer  "living_units"
    t.integer  "stories"
    t.integer  "number_of_building"
    t.integer  "year_built"
    t.integer  "effective_year_built"
    t.integer  "millage_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parcels", ["folio"], name: "index_parcels_on_folio", unique: true, using: :btree

  create_table "raw_building_details", id: false, force: true do |t|
    t.string "Folio"
    t.string "BuildingNumber"
    t.string "LineNumber"
    t.string "Type"
    t.string "Code"
    t.string "Percent"
    t.string "Points"
    t.string "SF_ADJ"
    t.string "Element"
    t.string "Description"
  end

  add_index "raw_building_details", ["Folio"], name: "index_raw_building_details_on_Folio", using: :btree

  create_table "raw_building_traverses", id: false, force: true do |t|
    t.string "Folio"
    t.string "BuildingNumber"
    t.string "ImprovementType"
    t.text   "Traverse"
  end

  add_index "raw_building_traverses", ["Folio"], name: "index_raw_building_traverses_on_Folio", using: :btree

  create_table "raw_buildings", id: false, force: true do |t|
    t.string "Folio"
    t.string "Municipality"
    t.string "SegNum"
    t.string "BuildingClass"
    t.string "QualityCode"
    t.string "ActualYear"
    t.string "EffectiveYear"
    t.string "RemodelYear"
    t.string "NormalDepr"
    t.string "AdditiveDepr"
    t.string "MultiplicativeDepr"
    t.string "OverrideDepr"
    t.string "PreferredDepr"
    t.string "TotalDeprAdj"
    t.string "AccruedDepr"
    t.string "TotalDepr"
    t.string "NHFactor"
    t.string "BasicPoints"
    t.string "TotalAdjPoints"
    t.string "TotalPoints"
    t.string "BaseRate"
    t.string "AdjBasePrice"
    t.string "NewConstValue"
    t.string "DemoValue"
    t.string "BaseValue"
    t.string "MarketPct"
    t.string "ActualArea"
    t.string "PctComp"
    t.string "SpecialRate"
    t.string "DateAppraised"
    t.string "BedroomCount"
    t.string "BathroomCount"
    t.string "UnitCount"
    t.string "FloorCount"
    t.string "BuildingNum"
  end

  add_index "raw_buildings", ["Folio"], name: "index_raw_buildings_on_Folio", using: :btree

  create_table "raw_extra_features", id: false, force: true do |t|
    t.string "Folio"
    t.string "Municipality"
    t.string "LnNum"
    t.string "Grade"
    t.string "Code"
    t.string "BldNum"
    t.string "Length"
    t.string "Width"
    t.string "Height"
    t.string "OrigCond"
    t.string "UnitPrice"
    t.string "AdjUnitPrice"
    t.string "YearBuilt"
    t.string "EffectiveYearBuilt"
    t.string "Units"
    t.string "UnitDepr"
    t.string "TotalDepr"
    t.string "DeprValue"
    t.string "BaseValue"
    t.string "MarketPct"
    t.string "CapType"
    t.string "YearOnRoll"
    t.string "PctCond"
    t.string "Note"
    t.string "NewConstValue"
    t.string "DemoValue"
    t.string "AltDescription"
    t.string "ConditionCode"
    t.string "OverrideDepr"
    t.string "AbatementValue"
    t.string "LevelOfAssessment"
    t.string "ExemptValue"
    t.string "ObsolPct"
    t.string "IndexFactor"
    t.string "ReplPrice"
    t.string "DeletedFlag"
    t.string "OverrideValue"
    t.string "MarketValue"
  end

  add_index "raw_extra_features", ["Folio"], name: "index_raw_extra_features_on_Folio", using: :btree

  create_table "raw_lands", id: false, force: true do |t|
    t.string "Folio"
    t.string "District"
    t.string "UseCode"
    t.string "LineNumber"
    t.string "Zone"
    t.string "Front"
    t.string "Depth"
    t.string "Units"
    t.string "Type"
    t.string "DepthFactor"
    t.string "DepthTable"
    t.string "InfluenceCode"
  end

  add_index "raw_lands", ["Folio"], name: "index_raw_lands_on_Folio", using: :btree

  create_table "raw_legals", id: false, force: true do |t|
    t.string "Folio"
    t.string "LineNumber"
    t.string "Description"
  end

  add_index "raw_legals", ["Folio"], name: "index_raw_legals_on_Folio", using: :btree

  create_table "raw_parcels", id: false, force: true do |t|
    t.string "Folio"
    t.string "Municipality"
    t.string "Owner1"
    t.string "Owner2"
    t.string "Owner3"
    t.string "MailingAddressLine1"
    t.string "MailingAddressLine2"
    t.string "MailingAddressLine3"
    t.string "City"
    t.string "State"
    t.string "Zip"
    t.string "Country"
    t.string "SiteAddress"
    t.string "StreetNumber"
    t.string "StreetPrefix"
    t.string "StreetName"
    t.string "StreetNumberSuffix"
    t.string "StreetSuffix"
    t.string "StreetDirection"
    t.string "CondoUnit"
    t.string "SiteCity"
    t.string "SiteZip"
    t.string "DORCode"
    t.string "Zoning"
    t.string "SqFtg"
    t.string "LotSF"
    t.string "Acres"
    t.string "Bedrooms"
    t.string "Baths"
    t.string "HalfBaths"
    t.string "LivingUnits"
    t.string "Stories"
    t.string "NumberOfBuilding"
    t.string "YearBuilt"
    t.string "EffectiveYearBuilt"
    t.string "MillageCode"
    t.string "CurrentYear"
    t.string "CurrentLandValue"
    t.string "CurrentBuildingValue"
    t.string "CurrentExtraFeatureValue"
    t.string "CurrentTotalValue"
    t.string "CurrentHomesteadExValue"
    t.string "CurrentCountySecondHomesteadExValue"
    t.string "CurrentCitySecondHomesteadExValue"
    t.string "CurrentWindowExValue"
    t.string "CurrentCountyOtherExValue"
    t.string "CurrentCityOtherExValue"
    t.string "CurrentDisabilityExValue"
    t.string "CurrentCountySeniorExValue"
    t.string "CurrentCitySeniorExValue"
    t.string "CurrentBlindExValue"
    t.string "CurrentAssessedValue"
    t.string "CurrentCountyExemptionValue"
    t.string "CurrentCountyTaxableValue"
    t.string "CurrentCityExemptionValue"
    t.string "CurrentCityTaxableValue"
    t.string "CurrentRegionalExemptionValue"
    t.string "CurrentRegionalTaxableValue"
    t.string "CurrentSchoolExemptionValue"
    t.string "CurrentSchoolTaxableValue"
    t.string "PriorYear"
    t.string "PriorLandValue"
    t.string "PriorBuildingValue"
    t.string "PriorExtraFeatureValue"
    t.string "PriorTotalValue"
    t.string "PriorHomesteadExValue"
    t.string "PriorCountySecondHomesteadExValue"
    t.string "PriorCitySecondHomesteadExValue"
    t.string "PriorWindowExValue"
    t.string "PriorCountyOtherExValue"
    t.string "PriorCityOtherExValue"
    t.string "PriorDisabilityExValue"
    t.string "PriorCountySeniorExValue"
    t.string "PriorCitySeniorExValue"
    t.string "PriorBlindExValue"
    t.string "PriorAssessedValue"
    t.string "PriorCountyExemptionValue"
    t.string "PriorCountyTaxableValue"
    t.string "PriorCityExemptionValue"
    t.string "PriorCityTaxableValue"
    t.string "PriorRegionalExemptionValue"
    t.string "PriorRegionalTaxableValue"
    t.string "PriorSchoolExemptionValue"
    t.string "PriorSchoolTaxableValue"
    t.string "Prior2Year"
    t.string "Prior2LandValue"
    t.string "Prior2BuildingValue"
    t.string "Prior2ExtraFeatureValue"
    t.string "Prior2TotalValue"
    t.string "Prior2HomesteadExValue"
    t.string "Prior2CountySecondHomesteadExValue"
    t.string "Prior2CitySecondHomesteadExValue"
    t.string "Prior2WindowExValue"
    t.string "Prior2CountyOtherExValue"
    t.string "Prior2CityOtherExValue"
    t.string "Prior2DisabilityExValue"
    t.string "Prior2CountySeniorExValue"
    t.string "Prior2CitySeniorExValue"
    t.string "Prior2BlindExValue"
    t.string "Prior2AssessedValue"
    t.string "Prior2CountyExemptionValue"
    t.string "Prior2CountyTaxableValue"
    t.string "Prior2CityExemptionValue"
    t.string "Prior2CityTaxableValue"
    t.string "Prior2RegionalExemptionValue"
    t.string "Prior2RegionalTaxableValue"
    t.string "Prior2SchoolExemptionValue"
    t.string "Prior2SchoolTaxableValue"
  end

  add_index "raw_parcels", ["Folio"], name: "index_raw_parcels_on_Folio", unique: true, using: :btree

  create_table "raw_sales", id: false, force: true do |t|
    t.string "Folio"
    t.string "Municipality"
    t.string "SaleID"
    t.string "OR_BK"
    t.string "OR_PG"
    t.string "TransferCode"
    t.string "Grantor"
    t.string "Grantee"
    t.string "DateOfSale"
    t.string "Price"
    t.string "VI"
    t.string "QU_FLG"
    t.string "DORCode"
    t.string "SiteAddress"
    t.string "StreetNumber"
    t.string "StreetPrefix"
    t.string "StreetName"
    t.string "StreetNumberSuffix"
    t.string "StreetSuffix"
    t.string "StreetDirection"
    t.string "CondoUnit"
    t.string "SiteCity"
    t.string "SiteZip"
    t.string "MailingAddressLine1"
    t.string "MailingAddressLine2"
    t.string "MailingAddressLine3"
    t.string "City"
    t.string "State"
    t.string "Zip"
    t.string "Country"
    t.string "SalesCode"
    t.string "Owner1"
    t.string "Owner2"
    t.string "Owner3"
    t.string "Zoning"
    t.string "SqFtg"
    t.string "LotSF"
    t.string "Acres"
    t.string "Bedrooms"
    t.string "Baths"
    t.string "HalfBaths"
    t.string "LivingUnits"
    t.string "Stories"
    t.string "NumberOfBuilding"
    t.string "YearBuilt"
    t.string "EffectiveYearBuilt"
  end

  create_table "tempparcels", id: false, force: true do |t|
    t.string  "Folio"
    t.string  "Municipality"
    t.string  "Owner1"
    t.string  "Owner2"
    t.string  "Owner3"
    t.string  "MailingAddressLine1"
    t.string  "MailingAddressLine2"
    t.string  "MailingAddressLine3"
    t.string  "City"
    t.string  "State"
    t.string  "Zip"
    t.string  "Country"
    t.string  "SiteAddress"
    t.string  "StreetNumber"
    t.string  "StreetPrefix"
    t.string  "StreetName"
    t.string  "StreetNumberSuffix"
    t.string  "StreetSuffix"
    t.string  "StreetDirection"
    t.string  "CondoUnit"
    t.string  "SiteCity"
    t.string  "SiteZip"
    t.integer "DORCode"
    t.integer "Zoning"
    t.decimal "SqFtg"
    t.decimal "LotSF"
    t.decimal "Acres"
    t.integer "Bedrooms"
    t.decimal "Baths"
    t.integer "HalfBaths"
    t.integer "LivingUnits"
    t.integer "Stories"
    t.integer "NumberOfBuilding"
    t.integer "YearBuilt"
    t.integer "EffectiveYearBuilt"
    t.integer "MillageCode"
    t.integer "CurrentYear"
    t.decimal "CurrentLandValue"
    t.decimal "CurrentBuildingValue"
    t.string  "CurrentExtraFeatureValue"
    t.decimal "CurrentTotalValue"
    t.decimal "CurrentHomesteadExValue"
    t.decimal "CurrentCountySecondHomesteadExValue"
    t.decimal "CurrentCitySecondHomesteadExValue"
    t.decimal "CurrentWindowExValue"
    t.decimal "CurrentCountyOtherExValue"
    t.decimal "CurrentCityOtherExValue"
    t.decimal "CurrentDisabilityExValue"
    t.decimal "CurrentCountySeniorExValue"
    t.decimal "CurrentCitySeniorExValue"
    t.decimal "CurrentBlindExValue"
    t.decimal "CurrentAssessedValue"
    t.decimal "CurrentCountyExemptionValue"
    t.decimal "CurrentCountyTaxableValue"
    t.decimal "CurrentCityExemptionValue"
    t.decimal "CurrentCityTaxableValue"
    t.decimal "CurrentRegionalExemptionValue"
    t.decimal "CurrentRegionalTaxableValue"
    t.decimal "CurrentSchoolExemptionValue"
    t.decimal "CurrentSchoolTaxableValue"
    t.integer "PriorYear"
    t.decimal "PriorLandValue"
    t.decimal "PriorBuildingValue"
    t.decimal "PriorExtraFeatureValue"
    t.decimal "PriorTotalValue"
    t.decimal "PriorHomesteadExValue"
    t.decimal "PriorCountySecondHomesteadExValue"
    t.decimal "PriorCitySecondHomesteadExValue"
    t.decimal "PriorWindowExValue"
    t.decimal "PriorCountyOtherExValue"
    t.decimal "PriorCityOtherExValue"
    t.decimal "PriorDisabilityExValue"
    t.decimal "PriorCountySeniorExValue"
    t.decimal "PriorCitySeniorExValue"
    t.decimal "PriorBlindExValue"
    t.decimal "PriorAssessedValue"
    t.decimal "PriorCountyExemptionValue"
    t.decimal "PriorCountyTaxableValue"
    t.decimal "PriorCityExemptionValue"
    t.decimal "PriorCityTaxableValue"
    t.decimal "PriorRegionalExemptionValue"
    t.decimal "PriorRegionalTaxableValue"
    t.decimal "PriorSchoolExemptionValue"
    t.decimal "PriorSchoolTaxableValue"
    t.integer "Prior2Year"
    t.decimal "Prior2LandValue"
    t.decimal "Prior2BuildingValue"
    t.decimal "Prior2ExtraFeatureValue"
    t.decimal "Prior2TotalValue"
    t.decimal "Prior2HomesteadExValue"
    t.decimal "Prior2CountySecondHomesteadExValue"
    t.decimal "Prior2CitySecondHomesteadExValue"
    t.decimal "Prior2WindowExValue"
    t.decimal "Prior2CountyOtherExValue"
    t.decimal "Prior2CityOtherExValue"
    t.decimal "Prior2DisabilityExValue"
    t.decimal "Prior2CountySeniorExValue"
    t.decimal "Prior2CitySeniorExValue"
    t.decimal "Prior2BlindExValue"
    t.decimal "Prior2AssessedValue"
    t.decimal "Prior2CountyExemptionValue"
    t.decimal "Prior2CountyTaxableValue"
    t.decimal "Prior2CityExemptionValue"
    t.decimal "Prior2CityTaxableValue"
    t.decimal "Prior2RegionalExemptionValue"
    t.decimal "Prior2RegionalTaxableValue"
    t.decimal "Prior2SchoolExemptionValue"
    t.string  "Prior2SchoolTaxableValue"
  end

  add_foreign_key "parcel_tax_rolls", "parcels", name: "parcel_tax_rolls_parcel_id_fk", dependent: :delete

end
