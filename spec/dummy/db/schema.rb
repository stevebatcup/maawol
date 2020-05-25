# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_05_25_182001) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_logs", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "service"
    t.string "request_type"
    t.string "request_method"
    t.text "request_data"
    t.text "response"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["service"], name: "index_api_logs_on_service"
    t.index ["user_id"], name: "index_api_logs_on_user_id"
  end

  create_table "audio_files", force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.integer "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "token"
    t.integer "file_tmp_media_id"
  end

  create_table "audio_files_lessons", id: false, force: :cascade do |t|
    t.bigint "audio_file_id"
    t.bigint "lesson_id"
    t.index ["audio_file_id"], name: "index_audio_files_lessons_on_audio_file_id"
    t.index ["lesson_id"], name: "index_audio_files_lessons_on_lesson_id"
  end

  create_table "authors", force: :cascade do |t|
    t.string "name"
    t.string "avatar"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "referral_token"
    t.integer "subscription_fee_split"
    t.integer "avatar_tmp_media_id"
    t.boolean "is_main", default: false
  end

  create_table "basket_items", force: :cascade do |t|
    t.integer "owner_id"
    t.string "owner_type"
    t.integer "quantity"
    t.integer "item_id"
    t.string "item_type"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["owner_id", "owner_type"], name: "index_basket_items_on_owner_id_and_owner_type"
  end

  create_table "baskets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "paypal_payment_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "root_category_id"
    t.string "slug"
    t.index ["name"], name: "index_categories_on_name"
  end

  create_table "categories_courses", force: :cascade do |t|
    t.bigint "category_id"
    t.bigint "course_id"
    t.index ["category_id"], name: "index_categories_courses_on_category_id"
    t.index ["course_id"], name: "index_categories_courses_on_course_id"
  end

  create_table "categories_lessons", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "lesson_id"
    t.index ["category_id"], name: "index_categories_lessons_on_category_id"
    t.index ["lesson_id"], name: "index_categories_lessons_on_lesson_id"
  end

  create_table "cms_content_blocks", force: :cascade do |t|
    t.string "title"
    t.text "content"
    t.boolean "is_editable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.boolean "is_deletable", default: true
    t.string "slug"
  end

  create_table "cms_images", force: :cascade do |t|
    t.string "name"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cms_navbar_items", force: :cascade do |t|
    t.integer "navbar_id"
    t.string "name"
    t.string "url"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "desktop", default: true
    t.boolean "mobile", default: true
  end

  create_table "cms_navbars", force: :cascade do |t|
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cms_pages", force: :cascade do |t|
    t.string "title"
    t.string "slug"
    t.boolean "is_editable", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cms_sections", force: :cascade do |t|
    t.bigint "page_id"
    t.bigint "content_block_id"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["content_block_id"], name: "index_cms_sections_on_content_block_id"
    t.index ["page_id"], name: "index_cms_sections_on_page_id"
  end

  create_table "comments", id: :serial, force: :cascade do |t|
    t.integer "commentable_id"
    t.string "commentable_type"
    t.string "title"
    t.text "body"
    t.string "subject"
    t.integer "user_id", null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commentable_id", "commentable_type"], name: "index_comments_on_commentable_id_and_commentable_type"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.integer "user_id"
    t.string "subject"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "courses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.datetime "publish_date"
    t.integer "include_in_menu", default: 0
    t.integer "author_id", default: 1
    t.integer "image_tmp_media_id"
    t.string "slug"
  end

  create_table "courses_skill_levels", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "skill_level_id"
    t.index ["course_id"], name: "index_courses_skill_levels_on_course_id"
    t.index ["skill_level_id"], name: "index_courses_skill_levels_on_skill_level_id"
  end

  create_table "courses_tags", id: false, force: :cascade do |t|
    t.integer "course_id"
    t.integer "tag_id"
    t.index ["course_id"], name: "index_courses_tags_on_course_id"
    t.index ["tag_id"], name: "index_courses_tags_on_tag_id"
  end

  create_table "custom_user_subscription_options", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "subscription_option_id"
    t.boolean "redeemed", default: false
  end

  create_table "discount_code_subscription_options", id: :serial, force: :cascade do |t|
    t.integer "discount_code_id"
    t.integer "subscription_option_id"
    t.string "discount_type"
    t.string "discount_value"
    t.integer "display_sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_codes", id: :serial, force: :cascade do |t|
    t.string "code"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.integer "use_count"
    t.integer "redemption_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "downloadables", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image"
    t.string "token"
    t.integer "author_id", default: 1
    t.integer "file_tmp_media_id"
    t.integer "image_tmp_media_id"
  end

  create_table "downloadables_lessons", id: false, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "downloadable_id"
    t.index ["downloadable_id"], name: "index_downloadables_lessons_on_downloadable_id"
    t.index ["lesson_id"], name: "index_downloadables_lessons_on_lesson_id"
  end

  create_table "favourites", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "income_reports", force: :cascade do |t|
    t.integer "month"
    t.integer "year"
    t.integer "subscription_payments_count"
    t.decimal "subscription_payments_total", precision: 8, scale: 2
    t.integer "store_payments_count"
    t.decimal "store_payments_total", precision: 8, scale: 2
    t.decimal "total_income", precision: 8, scale: 2
    t.integer "profit_split_percentage"
    t.decimal "earnings", precision: 8, scale: 2
    t.integer "status"
    t.text "payment_notes"
    t.date "paid_on"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lesson_recommendations", force: :cascade do |t|
    t.integer "recommender_lesson_id"
    t.integer "recommended_lesson_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "lessons", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "course_only"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "content"
    t.datetime "publish_date"
    t.string "slug"
    t.boolean "is_free", default: false
    t.integer "comments_count", default: 0
    t.integer "author_id", default: 1
    t.integer "access_level", default: 0
    t.string "thumbnail"
    t.integer "thumbnail_tmp_media_id"
    t.index ["publish_date"], name: "index_lessons_on_publish_date"
    t.index ["slug"], name: "index_lessons_on_slug"
  end

  create_table "lessons_playlists", id: false, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "playlist_id"
    t.index ["lesson_id"], name: "index_lessons_playlists_on_lesson_id"
    t.index ["playlist_id"], name: "index_lessons_playlists_on_playlist_id"
  end

  create_table "lessons_tags", id: false, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "tag_id"
    t.index ["lesson_id"], name: "index_lessons_tags_on_lesson_id"
    t.index ["tag_id"], name: "index_lessons_tags_on_tag_id"
  end

  create_table "lessons_users", id: false, force: :cascade do |t|
    t.bigint "lesson_id"
    t.bigint "user_id"
    t.index ["lesson_id"], name: "index_lessons_users_on_lesson_id"
    t.index ["user_id"], name: "index_lessons_users_on_user_id"
  end

  create_table "lessons_videos", id: false, force: :cascade do |t|
    t.integer "lesson_id"
    t.integer "video_id"
    t.index ["lesson_id"], name: "index_lessons_videos_on_lesson_id"
    t.index ["video_id"], name: "index_lessons_videos_on_video_id"
  end

  create_table "playlists", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "spotify_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "apple_music_url"
    t.string "amazon_music_url"
  end

  create_table "product_payments", force: :cascade do |t|
    t.integer "product_id"
    t.decimal "amount", precision: 8, scale: 2
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "payment_system"
    t.string "email"
    t.string "first_name"
    t.string "last_name"
  end

  create_table "product_permissions", force: :cascade do |t|
    t.integer "product_id"
    t.string "token"
    t.integer "download_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expires_at"
  end

  create_table "products", force: :cascade do |t|
    t.bigint "store_id"
    t.integer "sort"
    t.decimal "price", precision: 8, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "productable_id"
    t.string "productable_type"
    t.integer "author_fee_split", default: 0
    t.index ["store_id"], name: "index_products_on_store_id"
  end

  create_table "root_categories", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "slug"
  end

  create_table "site_images", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "image_tmp_media_id"
  end

  create_table "site_settings", force: :cascade do |t|
    t.string "name"
    t.text "value"
    t.boolean "is_editable", default: true
    t.string "slug"
  end

  create_table "skill_levels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stores", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.text "description"
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmp_media_id"
  end

  create_table "stuck_answers", force: :cascade do |t|
    t.integer "stuck_question_id"
    t.text "answer"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "stuck_questions", force: :cascade do |t|
    t.string "question"
    t.integer "sort"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "subscription_options", id: :serial, force: :cascade do |t|
    t.integer "days"
    t.integer "months"
    t.string "level"
    t.string "status"
    t.decimal "price", precision: 8, scale: 2
    t.integer "display_sort"
    t.text "description"
    t.string "tag"
    t.string "name"
    t.boolean "custom", default: false
    t.string "payment_system_plan"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "show_in_cloud"
    t.string "slug"
    t.index ["slug"], name: "index_tags_on_slug"
  end

  create_table "teachings", id: :serial, force: :cascade do |t|
    t.integer "course_id"
    t.integer "lesson_id"
    t.integer "sort"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_teachings_on_course_id"
    t.index ["lesson_id"], name: "index_teachings_on_lesson_id"
  end

  create_table "tmp_media", force: :cascade do |t|
    t.string "file_type"
    t.string "media_file"
    t.string "resource_class"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "resource_attribute"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.boolean "is_admin", default: false
    t.integer "status"
    t.string "avatar"
    t.boolean "receives_weekly_digest", default: true
    t.integer "referral_author_id"
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128
    t.string "encrypted_password"
    t.integer "author_id"
    t.integer "avatar_tmp_media_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["remember_token"], name: "index_users_on_remember_token"
  end

  create_table "users_subscription_payments", id: :serial, force: :cascade do |t|
    t.integer "users_subscription_id"
    t.string "notification_id"
    t.decimal "amount", precision: 8, scale: 2
    t.string "status"
    t.datetime "paid_at"
    t.boolean "first_payment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_subscriptions", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "status"
    t.integer "subscription_option_id"
    t.datetime "ends_at"
    t.integer "successful_recurring_payments"
    t.decimal "initial_price", precision: 8, scale: 2
    t.string "cancellation_reason"
    t.datetime "starts_at"
    t.integer "discount_code_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remote_customer_id"
    t.string "remote_subscription_id"
    t.datetime "next_payment_due_at"
    t.string "payment_system"
    t.index ["remote_customer_id"], name: "index_users_subscriptions_on_remote_customer_id"
  end

  create_table "videos", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "thumbnail"
    t.json "vimeo_data"
    t.boolean "is_for_homepage", default: false
    t.string "vimeo_id"
    t.integer "status"
    t.string "tmp_video_file"
    t.integer "tmp_video_file_tmp_media_id"
    t.integer "duration_in_seconds"
  end

  create_table "views", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "watch_laters", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "lesson_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
