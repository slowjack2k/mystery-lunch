class CreateParticipants < ActiveRecord::Migration[7.0]
  def change
    create_table :participants do |t|
      t.references :lunch, null: false
      t.references :employee, null: false
      t.string :lunch_group, null: false
      t.integer :lock_version
      t.timestamps
    end

    add_index(:participants, [:lunch_id, :employee_id], unique: true)
    add_index(:participants, [:lunch_id, :lunch_group])
  end
end
