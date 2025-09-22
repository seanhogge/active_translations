class CreatePages < ActiveRecord::Migration[8.0]
  def change
    create_table :pages do |t|
      t.string :title
      t.string :heading
      t.string :subhead
      t.text :content
      t.boolean :published, default: false

      t.timestamps
    end
  end
end
