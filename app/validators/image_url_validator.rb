class ImageUrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if not value.attachment.image?
      record.errors[attribute] << (options[:message] || "must be a URL for GIF, JPEG or PNG image.")
    end
  end
end