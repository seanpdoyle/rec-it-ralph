class CreateAttractions < ActiveRecord::Migration[6.1]
  def change
    create_table :attractions do |t|
      t.citext :name, null: false
    end
  end
end
