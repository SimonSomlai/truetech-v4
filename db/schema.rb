# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190304081616) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "articles", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "body"
    t.string   "image"
    t.integer  "user_id"
    t.string   "category"
    t.boolean  "posted",         default: false
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "en_title"
    t.text     "en_description"
    t.text     "en_body"
    t.string   "slug_en"
    t.string   "slug_nl"
    t.string   "image_tmp"
    t.index ["category"], name: "index_articles_on_category", using: :btree
    t.index ["posted"], name: "index_articles_on_posted", using: :btree
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree
  end

  create_table "friendly_id_slugs", force: :cascade do |t|
    t.string   "slug",                      null: false
    t.integer  "sluggable_id",              null: false
    t.string   "sluggable_type", limit: 50
    t.string   "scope"
    t.datetime "created_at"
    t.index ["slug", "sluggable_type", "scope"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope", unique: true, using: :btree
    t.index ["slug", "sluggable_type"], name: "index_friendly_id_slugs_on_slug_and_sluggable_type", using: :btree
    t.index ["sluggable_id"], name: "index_friendly_id_slugs_on_sluggable_id", using: :btree
    t.index ["sluggable_type"], name: "index_friendly_id_slugs_on_sluggable_type", using: :btree
  end

  create_table "pages", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "body"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.string   "slug"
    t.index ["slug"], name: "index_pages_on_slug", unique: true, using: :btree
  end

  create_table "project_images", force: :cascade do |t|
    t.integer  "project_id"
    t.text     "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "images_tmp"
    t.index ["project_id"], name: "index_project_images_on_project_id", using: :btree
  end

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.text     "features"
    t.string   "link"
    t.string   "service"
    t.string   "skills"
    t.integer  "user_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.string   "slug"
    t.text     "en_description"
    t.boolean  "follow_up"
    t.index ["follow_up"], name: "index_projects_on_follow_up", using: :btree
    t.index ["service"], name: "index_projects_on_service", using: :btree
    t.index ["slug"], name: "index_projects_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_projects_on_user_id", using: :btree
  end

  create_table "settings", force: :cascade do |t|
    t.string   "key"
    t.string   "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_settings_on_key", using: :btree
  end

  create_table "testimonials", force: :cascade do |t|
    t.string   "name"
    t.string   "company"
    t.text     "quote"
    t.string   "image"
    t.string   "link"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text     "en_quote"
    t.string   "image_tmp"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",               default: false
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "profile_picture"
    t.string   "profile_picture_tmp"
    t.index ["name"], name: "index_users_on_name", using: :btree
  end

  create_table "visits", force: :cascade do |t|
    t.date     "date"
    t.integer  "visitors"
    t.integer  "pageviews"
    t.text     "referrers"
    t.text     "keywords"
    t.text     "top_content"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["date"], name: "index_visits_on_date", using: :btree
  end

  add_foreign_key "articles", "users"
  add_foreign_key "project_images", "projects"
  add_foreign_key "projects", "users"
end
