class CreateThesisAnnotations < ActiveRecord::Migration[7.0]
  def change
    create_table :thesis_annotations do |t|
      t.string :annotation
      t.string :annot_id

      t.timestamps
    end
  end
end
