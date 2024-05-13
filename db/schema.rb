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

ActiveRecord::Schema.define(version: 2022_06_18_114851) do

  create_table "annotations", force: :cascade do |t|
    t.string "annotation"
    t.string "annot_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id"
    t.string "annotation_type"
    t.index ["user_id", "annot_id", "annotation_type"], name: "index_annotations_on_user_id_and_annot_id_and_annotation_type", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.string "number_semester"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["number_semester"], name: "uniq_number_semester_per_course", unique: true
  end

  create_table "courses_users", id: false, force: :cascade do |t|
    t.integer "course_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "course_id"], name: "index_courses_users_on_user_id_and_course_id", unique: true
  end

  create_table "keywords", force: :cascade do |t|
    t.string "keywords"
    t.string "user_id"
    t.string "annot_id"
    t.string "kw_type"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "annot_id", "kw_type"], name: "index_keywords_on_user_id_and_annot_id_and_kw_type", unique: true
  end

  create_table "people", force: :cascade do |t|
    t.string "tiss_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "first_name"
    t.string "last_name"
    t.index ["tiss_id"], name: "uniq_tiss_id_per_person", unique: true
  end

  create_table "people_users", id: false, force: :cascade do |t|
    t.integer "person_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "person_id"], name: "index_people_users_on_user_id_and_person_id", unique: true
  end

  create_table "projects", force: :cascade do |t|
    t.string "project_id"
    t.string "title"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["project_id"], name: "uniq_project_id_per_project", unique: true
  end

  create_table "projects_users", id: false, force: :cascade do |t|
    t.integer "project_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "project_id"], name: "index_projects_users_on_user_id_and_project_id", unique: true
  end

  create_table "theses", force: :cascade do |t|
    t.string "title"
    t.string "thesis_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thesis_id"], name: "uniq_thesis_id_per_thesis", unique: true
  end

  create_table "theses_users", id: false, force: :cascade do |t|
    t.integer "thesis_id", null: false
    t.integer "user_id", null: false
    t.index ["user_id", "thesis_id"], name: "index_theses_users_on_user_id_and_thesis_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name", null: false
    t.string "password"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["name"], name: "index_users_on_name", unique: true
  end

end
