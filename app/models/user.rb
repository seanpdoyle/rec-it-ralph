class User < ApplicationRecord
  has_many :created_locations,
    class_name: "Location",
    foreign_key: :creator_id

  has_one_attached :avatar
end
