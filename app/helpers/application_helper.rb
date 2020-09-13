module ApplicationHelper
  def data_uri(value, format:)
    mime_type = Mime::Type.lookup_by_extension(format.to_s)

    "data:#{mime_type};base64,#{Base64.encode64(value)}"
  end
end
