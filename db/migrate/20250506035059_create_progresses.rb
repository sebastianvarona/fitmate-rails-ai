class CreateProgresses < ActiveRecord::Migration[8.0]
  def change
    create_table :progresses do |t|
      t.float :weight
      t.float :height
      t.float :chest
      t.float :arms
      t.float :waist
      t.float :hip
      t.float :thighs
      t.float :calves
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
