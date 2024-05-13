class RenameThesisAnnotationToAnnotation < ActiveRecord::Migration[7.0]
  def change
    rename_table :thesis_annotations, :annotations
  end
end
