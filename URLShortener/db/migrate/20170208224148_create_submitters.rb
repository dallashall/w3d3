class CreateSubmitters < ActiveRecord::Migration
  def change
    create_table :submitters do |t|
      t.integer :submitter_id, null: false
      t.integer :url_id, null: false
    end
  end
end
