class CreateRawExtraFeatures < ActiveRecord::Migration
  def change
    create_table :raw_extra_features, :id => false do |t|

			t.string :Folio
			t.string :Municipality
			t.string :LnNum
			t.string :Grade
			t.string :Code
			t.string :BldNum
			t.string :Length
			t.string :Width
			t.string :Height
			t.string :OrigCond
			t.string :UnitPrice
			t.string :AdjUnitPrice
			t.string :YearBuilt
			t.string :EffectiveYearBuilt
			t.string :Units
			t.string :UnitDepr
			t.string :TotalDepr
			t.string :DeprValue
			t.string :BaseValue
			t.string :MarketPct
			t.string :CapType
			t.string :YearOnRoll
			t.string :PctCond
			t.string :Note
			t.string :NewConstValue
			t.string :DemoValue
			t.string :AltDescription
			t.string :ConditionCode
			t.string :OverrideDepr
			t.string :AbatementValue
			t.string :LevelOfAssessment
			t.string :ExemptValue
			t.string :ObsolPct
			t.string :IndexFactor
			t.string :ReplPrice
			t.string :DeletedFlag
			t.string :OverrideValue
			t.string :MarketValue

      # t.timestamps
    end

    add_index :raw_extra_features, :Folio
  end
end
