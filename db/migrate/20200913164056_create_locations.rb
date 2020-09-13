class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    enable_extension :citext

    create_table :locations do |t|
      t.references :locatable, polymorphic: true, null: false, index: true

      t.citext :line1, null: false
      t.citext :line2, null: true
      t.citext :city, null: false
      t.citext :state, null: false
      t.citext :postal_code, null: false
      t.citext :country, null: false, default: "US"

      t.float :latitude, precision: 9
      t.float :longitude, precision: 9

      t.timestamps

      t.index [:latitude, :longitude]
    end
  end
end
