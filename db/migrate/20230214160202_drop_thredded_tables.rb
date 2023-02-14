class DropThreddedTables < ActiveRecord::Migration[6.0]
  def change
    drop_table :thredded_categories, force: :cascade
    drop_table :thredded_messageboard_groups, force: :cascade
    drop_table :thredded_messageboard_notifications_for_followed_topics, force: :cascade
    drop_table :thredded_messageboard_users, force: :cascade
    drop_table :thredded_messageboards, force: :cascade
    drop_table :thredded_notifications_for_followed_topics, force: :cascade
    drop_table :thredded_notifications_for_private_topics, force: :cascade
    drop_table :thredded_post_moderation_records, force: :cascade
    drop_table :thredded_posts, force: :cascade
    drop_table :thredded_private_posts, force: :cascade
    drop_table :thredded_private_topics, force: :cascade
    drop_table :thredded_private_users, force: :cascade
    drop_table :thredded_topic_categories, force: :cascade
    drop_table :thredded_topics, force: :cascade
    drop_table :thredded_user_details, force: :cascade
    drop_table :thredded_user_messageboard_preferences, force: :cascade
    drop_table :thredded_user_post_notifications, force: :cascade
    drop_table :thredded_user_preferences, force: :cascade
    drop_table :thredded_user_private_topic_read_states, force: :cascade
    drop_table :thredded_user_topic_follows, force: :cascade
    drop_table :thredded_user_topic_read_states, force: :cascade
  end
end
