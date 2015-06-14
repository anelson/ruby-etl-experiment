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
    t.string   "rowhash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parcel_tax_rolls", ["folio", "year", "rowhash"], name: "index_parcel_tax_rolls_on_folio_and_year_and_rowhash", unique: true, using: :btree
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
    t.string   "rowhash"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parcels", ["folio", "rowhash"], name: "index_parcels_on_folio_and_rowhash", unique: true, using: :btree
  add_index "parcels", ["folio"], name: "index_parcels_on_folio", unique: true, using: :btree

  create_table "raw_building_details", id: false, force: true do |t|
    t.string "folio",           null: false
    t.string "building_number"
    t.string "line_number"
    t.string "type"
    t.string "code"
    t.string "percent"
    t.string "points"
    t.string "sf_adj"
    t.string "element"
    t.string "description"
  end

  add_index "raw_building_details", ["folio"], name: "index_raw_building_details_on_folio", using: :btree

  create_table "raw_building_traverses", id: false, force: true do |t|
    t.string "folio",            null: false
    t.string "building_number"
    t.string "improvement_type"
    t.text   "traverse"
  end

  add_index "raw_building_traverses", ["folio"], name: "index_raw_building_traverses_on_folio", using: :btree

  create_table "raw_buildings", id: false, force: true do |t|
    t.string "folio",               null: false
    t.string "municipality"
    t.string "seg_num"
    t.string "building_class"
    t.string "quality_code"
    t.string "actual_year"
    t.string "effective_year"
    t.string "remodel_year"
    t.string "normal_depr"
    t.string "additive_depr"
    t.string "multiplicative_depr"
    t.string "override_depr"
    t.string "preferred_depr"
    t.string "total_depr_adj"
    t.string "accrued_depr"
    t.string "total_depr"
    t.string "n_h_factor"
    t.string "basic_points"
    t.string "total_adj_points"
    t.string "total_points"
    t.string "base_rate"
    t.string "adj_base_price"
    t.string "new_const_value"
    t.string "demo_value"
    t.string "base_value"
    t.string "market_pct"
    t.string "actual_area"
    t.string "pct_comp"
    t.string "special_rate"
    t.string "date_appraised"
    t.string "bedroom_count"
    t.string "bathroom_count"
    t.string "unit_count"
    t.string "floor_count"
    t.string "building_num"
  end

  add_index "raw_buildings", ["folio"], name: "index_raw_buildings_on_folio", using: :btree

  create_table "raw_extra_features", id: false, force: true do |t|
    t.string "folio",                null: false
    t.string "municipality"
    t.string "ln_num"
    t.string "grade"
    t.string "code"
    t.string "bld_num"
    t.string "length"
    t.string "width"
    t.string "height"
    t.string "orig_cond"
    t.string "unit_price"
    t.string "adj_unit_price"
    t.string "year_built"
    t.string "effective_year_built"
    t.string "units"
    t.string "unit_depr"
    t.string "total_depr"
    t.string "depr_value"
    t.string "base_value"
    t.string "market_pct"
    t.string "cap_type"
    t.string "year_on_roll"
    t.string "pct_cond"
    t.string "note"
    t.string "new_const_value"
    t.string "demo_value"
    t.string "alt_description"
    t.string "condition_code"
    t.string "override_depr"
    t.string "abatement_value"
    t.string "level_of_assessment"
    t.string "exempt_value"
    t.string "obsol_pct"
    t.string "index_factor"
    t.string "repl_price"
    t.string "deleted_flag"
    t.string "override_value"
    t.string "market_value"
  end

  add_index "raw_extra_features", ["folio"], name: "index_raw_extra_features_on_folio", using: :btree

  create_table "raw_lands", id: false, force: true do |t|
    t.string "folio",          null: false
    t.string "district"
    t.string "use_code"
    t.string "line_number"
    t.string "zone"
    t.string "front"
    t.string "depth"
    t.string "units"
    t.string "type"
    t.string "depth_factor"
    t.string "depth_table"
    t.string "influence_code"
  end

  add_index "raw_lands", ["folio"], name: "index_raw_lands_on_folio", using: :btree

  create_table "raw_legals", id: false, force: true do |t|
    t.string "folio",       null: false
    t.string "line_number"
    t.string "description"
  end

  add_index "raw_legals", ["folio"], name: "index_raw_legals_on_folio", using: :btree

  create_table "raw_parcels", id: false, force: true do |t|
    t.string  "folio",                                    null: false
    t.string  "municipality"
    t.string  "owner1"
    t.string  "owner2"
    t.string  "owner3"
    t.string  "mailing_address_line1"
    t.string  "mailing_address_line2"
    t.string  "mailing_address_line3"
    t.string  "city"
    t.string  "state"
    t.string  "zip"
    t.string  "country"
    t.string  "site_address"
    t.string  "street_number"
    t.string  "street_prefix"
    t.string  "street_name"
    t.string  "street_number_suffix"
    t.string  "street_suffix"
    t.string  "street_direction"
    t.string  "condo_unit"
    t.string  "site_city"
    t.string  "site_zip"
    t.integer "d_o_r_code"
    t.integer "zoning"
    t.decimal "sq_ftg"
    t.decimal "lot_s_f"
    t.decimal "acres"
    t.decimal "bedrooms"
    t.decimal "baths"
    t.integer "half_baths"
    t.integer "living_units"
    t.integer "stories"
    t.integer "number_of_building"
    t.integer "year_built"
    t.integer "effective_year_built"
    t.integer "millage_code"
    t.integer "current_year"
    t.decimal "current_land_value"
    t.decimal "current_building_value"
    t.decimal "current_extra_feature_value"
    t.decimal "current_total_value"
    t.decimal "current_homestead_ex_value"
    t.decimal "current_county_second_homestead_ex_value"
    t.decimal "current_city_second_homestead_ex_value"
    t.decimal "current_window_ex_value"
    t.decimal "current_county_other_ex_value"
    t.decimal "current_city_other_ex_value"
    t.decimal "current_disability_ex_value"
    t.decimal "current_county_senior_ex_value"
    t.decimal "current_city_senior_ex_value"
    t.decimal "current_blind_ex_value"
    t.decimal "current_assessed_value"
    t.decimal "current_county_exemption_value"
    t.decimal "current_county_taxable_value"
    t.decimal "current_city_exemption_value"
    t.decimal "current_city_taxable_value"
    t.decimal "current_regional_exemption_value"
    t.decimal "current_regional_taxable_value"
    t.decimal "current_school_exemption_value"
    t.decimal "current_school_taxable_value"
    t.integer "prior_year"
    t.decimal "prior_land_value"
    t.decimal "prior_building_value"
    t.decimal "prior_extra_feature_value"
    t.decimal "prior_total_value"
    t.decimal "prior_homestead_ex_value"
    t.decimal "prior_county_second_homestead_ex_value"
    t.decimal "prior_city_second_homestead_ex_value"
    t.decimal "prior_window_ex_value"
    t.decimal "prior_county_other_ex_value"
    t.decimal "prior_city_other_ex_value"
    t.decimal "prior_disability_ex_value"
    t.decimal "prior_county_senior_ex_value"
    t.decimal "prior_city_senior_ex_value"
    t.decimal "prior_blind_ex_value"
    t.decimal "prior_assessed_value"
    t.decimal "prior_county_exemption_value"
    t.decimal "prior_county_taxable_value"
    t.decimal "prior_city_exemption_value"
    t.decimal "prior_city_taxable_value"
    t.decimal "prior_regional_exemption_value"
    t.decimal "prior_regional_taxable_value"
    t.decimal "prior_school_exemption_value"
    t.decimal "prior_school_taxable_value"
    t.integer "prior2_year"
    t.decimal "prior2_land_value"
    t.decimal "prior2_building_value"
    t.decimal "prior2_extra_feature_value"
    t.decimal "prior2_total_value"
    t.decimal "prior2_homestead_ex_value"
    t.decimal "prior2_county_second_homestead_ex_value"
    t.decimal "prior2_city_second_homestead_ex_value"
    t.decimal "prior2_window_ex_value"
    t.decimal "prior2_county_other_ex_value"
    t.decimal "prior2_city_other_ex_value"
    t.decimal "prior2_disability_ex_value"
    t.decimal "prior2_county_senior_ex_value"
    t.decimal "prior2_city_senior_ex_value"
    t.decimal "prior2_blind_ex_value"
    t.decimal "prior2_assessed_value"
    t.decimal "prior2_county_exemption_value"
    t.decimal "prior2_county_taxable_value"
    t.decimal "prior2_city_exemption_value"
    t.decimal "prior2_city_taxable_value"
    t.decimal "prior2_regional_exemption_value"
    t.decimal "prior2_regional_taxable_value"
    t.decimal "prior2_school_exemption_value"
    t.decimal "prior2_school_taxable_value"
  end

  add_index "raw_parcels", ["folio"], name: "index_raw_parcels_on_folio", unique: true, using: :btree

  create_table "raw_sales", id: false, force: true do |t|
    t.string "folio",                 null: false
    t.string "municipality"
    t.string "sale_i_d"
    t.string "or_bk"
    t.string "or_pg"
    t.string "transfer_code"
    t.string "grantor"
    t.string "grantee"
    t.string "date_of_sale"
    t.string "price"
    t.string "vi"
    t.string "qu_flg"
    t.string "d_o_r_code"
    t.string "site_address"
    t.string "street_number"
    t.string "street_prefix"
    t.string "street_name"
    t.string "street_number_suffix"
    t.string "street_suffix"
    t.string "street_direction"
    t.string "condo_unit"
    t.string "site_city"
    t.string "site_zip"
    t.string "mailing_address_line1"
    t.string "mailing_address_line2"
    t.string "mailing_address_line3"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.string "country"
    t.string "sales_code"
    t.string "owner1"
    t.string "owner2"
    t.string "owner3"
    t.string "zoning"
    t.string "sq_ftg"
    t.string "lot_s_f"
    t.string "acres"
    t.string "bedrooms"
    t.string "baths"
    t.string "half_baths"
    t.string "living_units"
    t.string "stories"
    t.string "number_of_building"
    t.string "year_built"
    t.string "effective_year_built"
  end

  add_index "raw_sales", ["folio"], name: "index_raw_sales_on_folio", using: :btree

  add_foreign_key "parcel_tax_rolls", "parcels", name: "parcel_tax_rolls_parcel_id_fk", dependent: :delete

end
