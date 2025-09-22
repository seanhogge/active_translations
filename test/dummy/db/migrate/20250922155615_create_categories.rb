class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :name
      t.string :short_name
      t.string :path

      t.timestamps
    end
  end
end
