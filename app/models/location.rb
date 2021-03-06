class Location < ApplicationRecord
  has_many :recommendations

  belongs_to :creator, class_name: "User"

  geocoded_by :address

  delegated_type :locatable, types: %w[ Attraction Cafe Office Restaurant ]

  delegate :name, to: :locatable

  def nearby(*arguments)
    Location.near(self, *arguments).where.not(id: self)
  end

  def address
    [ line1, city, state, postal_code, country ].join(", ")
  end

  def to_coordinates
    [ latitude, longitude ]
  end
end
