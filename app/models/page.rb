class Page < ActiveRecord::Base
  # Friendly ID slugs, 1 language for now (slug)
  extend FriendlyId
  friendly_id :title, use: :slugged
end
