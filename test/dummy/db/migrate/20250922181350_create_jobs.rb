class CreateJobs < ActiveRecord::Migration[8.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.string :headline
      t.text :ad_html
      t.string :posted_status, default: :draft

      t.timestamps
    end
  end
end
