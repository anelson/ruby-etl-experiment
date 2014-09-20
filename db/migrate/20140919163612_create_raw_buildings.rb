class CreateRawBuildings < ActiveRecord::Migration
  def change
    create_table :raw_buildings, :id => false do |t|
			t.string :folio, :null => false
			t.string :municipality
			t.string :seg_num
			t.string :building_class
			t.string :quality_code
			t.string :actual_year
			t.string :effective_year
			t.string :remodel_year
			t.string :normal_depr
			t.string :additive_depr
			t.string :multiplicative_depr
			t.string :override_depr
			t.string :preferred_depr
			t.string :total_depr_adj
			t.string :accrued_depr
			t.string :total_depr
			t.string :n_h_factor
			t.string :basic_points
			t.string :total_adj_points
			t.string :total_points
			t.string :base_rate
			t.string :adj_base_price
			t.string :new_const_value
			t.string :demo_value
			t.string :base_value
			t.string :market_pct
			t.string :actual_area
			t.string :pct_comp
			t.string :special_rate
			t.string :date_appraised
			t.string :bedroom_count
			t.string :bathroom_count
			t.string :unit_count
			t.string :floor_count
			t.string :building_num

      # t.timestamps
    end

    add_index :raw_buildings, :folio
  end
end
