class Visit < ApplicationRecord
  serialize :referrers
  serialize :keywords
  serialize :top_content
end
