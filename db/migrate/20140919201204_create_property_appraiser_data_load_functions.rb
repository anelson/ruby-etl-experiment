class CreatePropertyAppraiserDataLoadFunctions < ActiveRecord::Migration
  def up
  	execute <<- ENDOFP

			CREATE OR REPLACE FUNCTION load_parcel(p raw_parcels) RETURNS VOID AS $$
				BEGIN
					--upsert a parcel record from the raw parcel data
					--note that tax roll data is re-normalized as part of this process
					WITH new_values (
						folio,
						municipality,
						owner1,
						owner2,
						owner3,
						mailing_address_line1,
						mailing_address_line2,
						mailing_address_line3,
						city,
						state,
						zip,
						country,
						site_address,
						street_number,
						street_prefix,
						street_name,
						street_number_suffix,
						street_suffix,
						street_direction,
						condo_unit,
						site_city,
						site_zip,
						d_o_r_code,
						zoning,
						sq_ftg,
						lot_s_f,
						acres,
						bedrooms,
						baths,
						half_baths,
						living_units,
						stories,
						number_of_building,
						year_built,
						effective_year_built,
						millage_code,
						created_at,
						updated_at
					) as (
						VALUES (
							p."Folio",
							p."Municipality",
							p."Owner1",
							p."Owner2",
							p."Owner3",
							p."MailingAddressLine1",
							p."MailingAddressLine2",
							p."MailingAddressLine3",
							p."City",
							p."State",
							p."Zip",
							p."Country",
							p."SiteAddress",
							p."StreetNumber",
							p."StreetPrefix",
							p."StreetName",
							p."StreetNumberSuffix",
							p."StreetSuffix",
							p."StreetDirection",
							p."CondoUnit",
							p."SiteCity",
							p."SiteZip",
							p."DORCode"::INTEGER,
							p."Zoning"::INTEGER,
							REPLACE(p."SqFtg", ',', '')::NUMERIC,
							REPLACE(p."LotSF", ',', '')::NUMERIC,
							REPLACE(p."Acres", ',', '')::NUMERIC,
							p."Bedrooms"::NUMERIC,
							p."Baths"::NUMERIC,
							p."HalfBaths"::INTEGER,
							p."LivingUnits"::INTEGER,
							p."Stories"::INTEGER,
							p."NumberOfBuilding"::INTEGER,
							p."YearBuilt"::INTEGER,
							p."EffectiveYearBuilt"::INTEGER,
							p."MillageCode"::INTEGER,
							NOW(),
							NOW()
						)
					),
					upsert AS 
					(
						UPDATE parcels SET
							municipality = nv.municipality,
							owner1 = nv.owner1,
							owner2 = nv.owner2,
							owner3 = nv.owner3,
							mailing_address_line1 = nv.mailing_address_line1,
							mailing_address_line2 = nv.mailing_address_line2,
							mailing_address_line3 = nv.mailing_address_line3,
							city = nv.city,
							state = nv.state,
							zip = nv.zip,
							country = nv.country,
							site_address = nv.site_address,
							street_number = nv.street_number,
							street_prefix = nv.street_prefix,
							street_name = nv.street_name,
							street_number_suffix = nv.street_number_suffix,
							street_suffix = nv.street_suffix,
							street_direction = nv.street_direction,
							condo_unit = nv.condo_unit,
							site_city = nv.site_city,
							site_zip = nv.site_zip,
							d_o_r_code = nv.d_o_r_code,
							zoning = nv.zoning,
							sq_ftg = nv.sq_ftg,
							lot_s_f = nv.lot_s_f,
							acres = nv.acres,
							bedrooms = nv.bedrooms,
							baths = nv.baths,
							half_baths = nv.half_baths,
							living_units = nv.living_units,
							stories = nv.stories,
							number_of_building = nv.number_of_building,
							year_built = nv.year_built,
							effective_year_built = nv.effective_year_built,
							millage_code = nv.millage_code,
							updated_at = nv.updated_at
						FROM new_values nv
						WHERE parcels.folio = nv.folio
						RETURNING parcels.*
					)
					INSERT INTO parcels (
						folio,
						municipality,
						owner1,
						owner2,
						owner3,
						mailing_address_line1,
						mailing_address_line2,
						mailing_address_line3,
						city,
						state,
						zip,
						country,
						site_address,
						street_number,
						street_prefix,
						street_name,
						street_number_suffix,
						street_suffix,
						street_direction,
						condo_unit,
						site_city,
						site_zip,
						d_o_r_code,
						zoning,
						sq_ftg,
						lot_s_f,
						acres,
						bedrooms,
						baths,
						half_baths,
						living_units,
						stories,
						number_of_building,
						year_built,
						effective_year_built,
						millage_code,
						created_at,
						updated_at
						)
					SELECT 
						folio,
						municipality,
						owner1,
						owner2,
						owner3,
						mailing_address_line1,
						mailing_address_line2,
						mailing_address_line3,
						city,
						state,
						zip,
						country,
						site_address,
						street_number,
						street_prefix,
						street_name,
						street_number_suffix,
						street_suffix,
						street_direction,
						condo_unit,
						site_city,
						site_zip,
						d_o_r_code,
						zoning,
						sq_ftg,
						lot_s_f,
						acres,
						bedrooms,
						baths,
						half_baths,
						living_units,
						stories,
						number_of_building,
						year_built,
						effective_year_built,
						millage_code,
						created_at,
						updated_at
					FROM new_values
					WHERE NOT EXISTS (SELECT 1 from upsert up WHERE up.folio = new_values.folio);
				END;
			$$ LANGUAGE plpgsql;

			CREATE OR REPLACE FUNCTION reload_raw_pa_data() RETURNS VOID AS $$
				DECLARE
					p raw_parcels%rowtype;
				BEGIN
					FOR p IN SELECT * from raw_parcels
					LOOP
						--For each raw parcel record, perform type conversion load child tables as well
						BEGIN TRANSACTION
						PERFORM load_parcel(p);
						COMMIT;
					END LOOP;
				END;
			$$ LANGUAGE plpgsql;
  	ENDOFP
  end

  def down
  	execute <<- ENDOFP
  		DROP FUNCTION IF EXISTS load_parcel;

  		DROP FUNCTION IF EXISTS reload_raw_pa_data;
  	ENDOFP
  end
end
