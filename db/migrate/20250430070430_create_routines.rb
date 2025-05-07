class CreateRoutines < ActiveRecord::Migration[8.0]
  def change
    create_table :routines do |t|
      t.string :title
      t.text :context
      t.text :content
      t.json :weekdays, default: "[]"
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
