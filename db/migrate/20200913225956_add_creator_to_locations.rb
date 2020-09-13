class AddCreatorToLocations < ActiveRecord::Migration[6.1]
  def change
    change_table :locations do |t|
      t.references :creator, null: false, foreign_key: {to_table: :users}
    end
  end
end
