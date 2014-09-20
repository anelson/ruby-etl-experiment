class CreateRawExtraFeatures < ActiveRecord::Migration
  def change
    create_table :raw_extra_features, :id => false do |t|

			t.string :folio, :null => false
			t.string :municipality
			t.string :ln_num
			t.string :grade
			t.string :code
			t.string :bld_num
			t.string :length
			t.string :width
			t.string :height
			t.string :orig_cond
			t.string :unit_price
			t.string :adj_unit_price
			t.string :year_built
			t.string :effective_year_built
			t.string :units
			t.string :unit_depr
			t.string :total_depr
			t.string :depr_value
			t.string :base_value
			t.string :market_pct
			t.string :cap_type
			t.string :year_on_roll
			t.string :pct_cond
			t.string :note
			t.string :new_const_value
			t.string :demo_value
			t.string :alt_description
			t.string :condition_code
			t.string :override_depr
			t.string :abatement_value
			t.string :level_of_assessment
			t.string :exempt_value
			t.string :obsol_pct
			t.string :index_factor
			t.string :repl_price
			t.string :deleted_flag
			t.string :override_value
			t.string :market_value

      # t.timestamps
    end

    add_index :raw_extra_features, :folio
  end
end
