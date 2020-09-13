class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.citext :biography
      t.citext :name
      t.citext :neighborhood

      t.timestamps
    end
  end
end
