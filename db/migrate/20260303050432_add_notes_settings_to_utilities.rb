class AddNotesSettingsToUtilities < ActiveRecord::Migration[6.1]
  def change
    add_column :utilities, :notes_settings, :jsonb
  end
end
