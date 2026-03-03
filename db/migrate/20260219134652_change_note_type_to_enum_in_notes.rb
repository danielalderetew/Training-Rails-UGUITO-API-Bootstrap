class ChangeNoteTypeToEnumInNotes < ActiveRecord::Migration[6.1]
    def change
    remove_column :notes, :note_type
    add_column :notes, :note_type, :integer, default: 0
  end
end
