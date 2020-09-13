module Locatable
  extend ActiveSupport::Concern

  included do
    has_one :location, as: :locatable, inverse_of: :locatable, touch: true

    delegate_missing_to :location
  end
end
