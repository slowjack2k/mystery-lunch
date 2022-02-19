# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_02_18_150248) do
  create_table "employees", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.string "name"
    t.string "department"
    t.integer "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_employees_on_deleted_at"
  end

  create_table "lunches", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.integer "year"
    t.integer "month"
    t.integer "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["year", "month"], name: "index_lunches_on_year_and_month", unique: true
  end

  create_table "participants", charset: "utf8mb4", collation: "utf8mb4_0900_ai_ci", force: :cascade do |t|
    t.bigint "lunch_id", null: false
    t.bigint "employee_id", null: false
    t.string "lunch_group", null: false
    t.integer "lock_version"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["employee_id"], name: "index_participants_on_employee_id"
    t.index ["lunch_id", "employee_id"], name: "index_participants_on_lunch_id_and_employee_id", unique: true
    t.index ["lunch_id", "lunch_group"], name: "index_participants_on_lunch_id_and_lunch_group"
    t.index ["lunch_id"], name: "index_participants_on_lunch_id"
  end
end
