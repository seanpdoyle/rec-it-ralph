class Current < ActiveSupport::CurrentAttributes
  def office
    Office.first
  end
end
