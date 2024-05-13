class CreateTheses < ActiveRecord::Migration[7.0]
  def change
    create_table :theses do |t|
      t.string :title
      t.string :thesis_id

      t.timestamps
    end
  end
end
