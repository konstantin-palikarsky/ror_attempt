class CreateKeywords < ActiveRecord::Migration[7.0]
  def change
    create_table :keywords do |t|
      t.string :keywords
      t.string :user_id
      t.string :annot_id
      t.string :kw_type

      t.timestamps
    end
  end
end
