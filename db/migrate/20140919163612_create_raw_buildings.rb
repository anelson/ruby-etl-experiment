class CreateRawBuildings < ActiveRecord::Migration
  def change
    create_table :raw_buildings, :id => false do |t|
			t.string :Folio
			t.string :Municipality
			t.string :SegNum
			t.string :BuildingClass
			t.string :QualityCode
			t.string :ActualYear
			t.string :EffectiveYear
			t.string :RemodelYear
			t.string :NormalDepr
			t.string :AdditiveDepr
			t.string :MultiplicativeDepr
			t.string :OverrideDepr
			t.string :PreferredDepr
			t.string :TotalDeprAdj
			t.string :AccruedDepr
			t.string :TotalDepr
			t.string :NHFactor
			t.string :BasicPoints
			t.string :TotalAdjPoints
			t.string :TotalPoints
			t.string :BaseRate
			t.string :AdjBasePrice
			t.string :NewConstValue
			t.string :DemoValue
			t.string :BaseValue
			t.string :MarketPct
			t.string :ActualArea
			t.string :PctComp
			t.string :SpecialRate
			t.string :DateAppraised
			t.string :BedroomCount
			t.string :BathroomCount
			t.string :UnitCount
			t.string :FloorCount
			t.string :BuildingNum

      # t.timestamps
    end

    add_index :raw_buildings, :Folio
  end
end
