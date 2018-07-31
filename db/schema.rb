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

ActiveRecord::Schema.define(version: 20180725192123) do

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
    t.index ["category"], name: "index_articles_on_category", using: :btree
    t.index ["posted"], name: "index_articles_on_posted", using: :btree
    t.index ["user_id"], name: "index_articles_on_user_id", using: :btree
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
  end

  create_table "thredded_categories", force: :cascade do |t|
    t.integer  "messageboard_id", null: false
    t.text     "name",            null: false
    t.text     "description"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "slug",            null: false
    t.index "lower(name) text_pattern_ops", name: "thredded_categories_name_ci", using: :btree
    t.index ["messageboard_id", "slug"], name: "index_thredded_categories_on_messageboard_id_and_slug", unique: true, using: :btree
    t.index ["messageboard_id"], name: "index_thredded_categories_on_messageboard_id", using: :btree
  end

  create_table "thredded_messageboard_groups", force: :cascade do |t|
    t.string   "name"
    t.integer  "position",   null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "thredded_messageboard_notifications_for_followed_topics", force: :cascade do |t|
    t.integer "user_id",                                   null: false
    t.integer "messageboard_id",                           null: false
    t.string  "notifier_key",    limit: 90,                null: false
    t.boolean "enabled",                    default: true, null: false
    t.index ["user_id", "messageboard_id", "notifier_key"], name: "thredded_messageboard_notifications_for_followed_topics_unique", unique: true, using: :btree
  end

  create_table "thredded_messageboard_users", force: :cascade do |t|
    t.integer  "thredded_user_detail_id",  null: false
    t.integer  "thredded_messageboard_id", null: false
    t.datetime "last_seen_at",             null: false
    t.index ["thredded_messageboard_id", "last_seen_at"], name: "index_thredded_messageboard_users_for_recently_active", using: :btree
    t.index ["thredded_messageboard_id", "thredded_user_detail_id"], name: "index_thredded_messageboard_users_primary", unique: true, using: :btree
  end

  create_table "thredded_messageboards", force: :cascade do |t|
    t.text     "name",                                  null: false
    t.text     "slug"
    t.text     "description"
    t.integer  "topics_count",          default: 0
    t.integer  "posts_count",           default: 0
    t.integer  "position",                              null: false
    t.integer  "last_topic_id"
    t.integer  "messageboard_group_id"
    t.datetime "created_at",                            null: false
    t.datetime "updated_at",                            null: false
    t.boolean  "locked",                default: false, null: false
    t.index ["messageboard_group_id"], name: "index_thredded_messageboards_on_messageboard_group_id", using: :btree
    t.index ["slug"], name: "index_thredded_messageboards_on_slug", unique: true, using: :btree
  end

  create_table "thredded_notifications_for_followed_topics", force: :cascade do |t|
    t.integer "user_id",                                null: false
    t.string  "notifier_key", limit: 90,                null: false
    t.boolean "enabled",                 default: true, null: false
    t.index ["user_id", "notifier_key"], name: "thredded_notifications_for_followed_topics_unique", unique: true, using: :btree
  end

  create_table "thredded_notifications_for_private_topics", force: :cascade do |t|
    t.integer "user_id",                                null: false
    t.string  "notifier_key", limit: 90,                null: false
    t.boolean "enabled",                 default: true, null: false
    t.index ["user_id", "notifier_key"], name: "thredded_notifications_for_private_topics_unique", unique: true, using: :btree
  end

  create_table "thredded_post_moderation_records", force: :cascade do |t|
    t.integer  "post_id"
    t.integer  "messageboard_id"
    t.text     "post_content"
    t.integer  "post_user_id"
    t.text     "post_user_name"
    t.integer  "moderator_id"
    t.integer  "moderation_state",          null: false
    t.integer  "previous_moderation_state", null: false
    t.datetime "created_at",                null: false
    t.index ["messageboard_id", "created_at"], name: "index_thredded_moderation_records_for_display", order: {"created_at"=>:desc}, using: :btree
  end

  create_table "thredded_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.string   "source",           limit: 191, default: "web"
    t.integer  "postable_id",                                  null: false
    t.integer  "messageboard_id",                              null: false
    t.integer  "moderation_state",                             null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.index "to_tsvector('english'::regconfig, content)", name: "thredded_posts_content_fts", using: :gist
    t.index ["messageboard_id"], name: "index_thredded_posts_on_messageboard_id", using: :btree
    t.index ["moderation_state", "updated_at"], name: "index_thredded_posts_for_display", using: :btree
    t.index ["postable_id", "created_at"], name: "index_thredded_posts_on_postable_id_and_created_at", using: :btree
    t.index ["postable_id"], name: "index_thredded_posts_on_postable_id", using: :btree
    t.index ["user_id"], name: "index_thredded_posts_on_user_id", using: :btree
  end

  create_table "thredded_private_posts", force: :cascade do |t|
    t.integer  "user_id"
    t.text     "content"
    t.integer  "postable_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
    t.index ["postable_id", "created_at"], name: "index_thredded_private_posts_on_postable_id_and_created_at", using: :btree
  end

  create_table "thredded_private_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "last_user_id"
    t.text     "title",                               null: false
    t.text     "slug",                                null: false
    t.integer  "posts_count",             default: 0
    t.string   "hash_id",      limit: 20,             null: false
    t.datetime "last_post_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["hash_id"], name: "index_thredded_private_topics_on_hash_id", using: :btree
    t.index ["last_post_at"], name: "index_thredded_private_topics_on_last_post_at", using: :btree
    t.index ["slug"], name: "index_thredded_private_topics_on_slug", unique: true, using: :btree
  end

  create_table "thredded_private_users", force: :cascade do |t|
    t.integer  "private_topic_id"
    t.integer  "user_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["private_topic_id"], name: "index_thredded_private_users_on_private_topic_id", using: :btree
    t.index ["user_id"], name: "index_thredded_private_users_on_user_id", using: :btree
  end

  create_table "thredded_topic_categories", force: :cascade do |t|
    t.integer "topic_id",    null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_thredded_topic_categories_on_category_id", using: :btree
    t.index ["topic_id"], name: "index_thredded_topic_categories_on_topic_id", using: :btree
  end

  create_table "thredded_topics", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "last_user_id"
    t.text     "title",                                       null: false
    t.text     "slug",                                        null: false
    t.integer  "messageboard_id",                             null: false
    t.integer  "posts_count",                 default: 0,     null: false
    t.boolean  "sticky",                      default: false, null: false
    t.boolean  "locked",                      default: false, null: false
    t.string   "hash_id",          limit: 20,                 null: false
    t.integer  "moderation_state",                            null: false
    t.datetime "last_post_at"
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.index "to_tsvector('english'::regconfig, title)", name: "thredded_topics_title_fts", using: :gist
    t.index ["hash_id"], name: "index_thredded_topics_on_hash_id", using: :btree
    t.index ["last_post_at"], name: "index_thredded_topics_on_last_post_at", using: :btree
    t.index ["messageboard_id"], name: "index_thredded_topics_on_messageboard_id", using: :btree
    t.index ["moderation_state", "sticky", "updated_at"], name: "index_thredded_topics_for_display", order: {"sticky"=>:desc, "updated_at"=>:desc}, using: :btree
    t.index ["slug"], name: "index_thredded_topics_on_slug", unique: true, using: :btree
    t.index ["user_id"], name: "index_thredded_topics_on_user_id", using: :btree
  end

  create_table "thredded_user_details", force: :cascade do |t|
    t.integer  "user_id",                                 null: false
    t.datetime "latest_activity_at"
    t.integer  "posts_count",                 default: 0
    t.integer  "topics_count",                default: 0
    t.datetime "last_seen_at"
    t.integer  "moderation_state",            default: 0, null: false
    t.datetime "moderation_state_changed_at"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.index ["latest_activity_at"], name: "index_thredded_user_details_on_latest_activity_at", using: :btree
    t.index ["moderation_state", "moderation_state_changed_at"], name: "index_thredded_user_details_for_moderations", order: {"moderation_state_changed_at"=>:desc}, using: :btree
    t.index ["user_id"], name: "index_thredded_user_details_on_user_id", unique: true, using: :btree
  end

  create_table "thredded_user_messageboard_preferences", force: :cascade do |t|
    t.integer  "user_id",                                  null: false
    t.integer  "messageboard_id",                          null: false
    t.boolean  "follow_topics_on_mention", default: true,  null: false
    t.boolean  "auto_follow_topics",       default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["user_id", "messageboard_id"], name: "thredded_user_messageboard_preferences_user_id_messageboard_id", unique: true, using: :btree
  end

  create_table "thredded_user_post_notifications", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "post_id",     null: false
    t.datetime "notified_at", null: false
    t.index ["post_id"], name: "index_thredded_user_post_notifications_on_post_id", using: :btree
    t.index ["user_id", "post_id"], name: "index_thredded_user_post_notifications_on_user_id_and_post_id", unique: true, using: :btree
  end

  create_table "thredded_user_preferences", force: :cascade do |t|
    t.integer  "user_id",                                  null: false
    t.boolean  "follow_topics_on_mention", default: true,  null: false
    t.boolean  "auto_follow_topics",       default: false, null: false
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.index ["user_id"], name: "index_thredded_user_preferences_on_user_id", unique: true, using: :btree
  end

  create_table "thredded_user_private_topic_read_states", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "postable_id", null: false
    t.datetime "read_at",     null: false
    t.index ["user_id", "postable_id"], name: "thredded_user_private_topic_read_states_user_postable", unique: true, using: :btree
  end

  create_table "thredded_user_topic_follows", force: :cascade do |t|
    t.integer  "user_id",              null: false
    t.integer  "topic_id",             null: false
    t.datetime "created_at",           null: false
    t.integer  "reason",     limit: 2
    t.index ["user_id", "topic_id"], name: "thredded_user_topic_follows_user_topic", unique: true, using: :btree
  end

  create_table "thredded_user_topic_read_states", force: :cascade do |t|
    t.integer  "user_id",     null: false
    t.integer  "postable_id", null: false
    t.datetime "read_at",     null: false
    t.index ["user_id", "postable_id"], name: "thredded_user_topic_read_states_user_postable", unique: true, using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email"
    t.string   "password_digest"
    t.boolean  "admin",           default: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "name"
    t.string   "profile_picture"
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
  add_foreign_key "thredded_messageboard_users", "thredded_messageboards", on_delete: :cascade
  add_foreign_key "thredded_messageboard_users", "thredded_user_details", on_delete: :cascade
  add_foreign_key "thredded_user_post_notifications", "thredded_posts", column: "post_id", on_delete: :cascade
  add_foreign_key "thredded_user_post_notifications", "users", on_delete: :cascade
end
