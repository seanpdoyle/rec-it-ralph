class CreateOffices < ActiveRecord::Migration[6.1]
  def change
    create_table :offices do |t|
      t.citext :name, null: false
    end
  end
end
