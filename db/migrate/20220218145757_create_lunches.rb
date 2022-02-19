class CreateLunches < ActiveRecord::Migration[7.0]
  def change
    create_table :lunches do |t|
      t.integer :year
      t.integer :month
      t.integer :lock_version
      t.timestamps
    end

    add_index(:lunches, [:year, :month], unique: true)
  end
end
