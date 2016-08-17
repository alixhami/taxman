class CreateTaxpayers < ActiveRecord::Migration
  def change
    create_table :taxpayers do |t|
      t.string :filing_status
      t.integer :gross_income

      t.timestamps null: false
    end
  end
end
