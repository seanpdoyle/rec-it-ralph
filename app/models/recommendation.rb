class Recommendation < ApplicationRecord
  belongs_to :location
  belongs_to :user

  has_rich_text :content
end
