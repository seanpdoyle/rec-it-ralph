class Office < ApplicationRecord
  include ActionText::Attachable
  include Locatable

  def to_attachable_partial_path
    "offices/attachable"
  end
end
