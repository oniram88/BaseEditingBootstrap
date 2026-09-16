# frozen_string_literal: true

# Ruby 3.4 + ActiveStorage 8.1 currently trips over blob metadata deserialization
# when attachments are created in the dummy app tests. The tests in this engine do
# not depend on custom blob metadata, so keep the upload path stable by returning
# an empty custom metadata hash.
ActiveSupport.on_load(:active_storage_blob) do
  def custom_metadata
    {}
  end

  def analyzed?
    true
  end
end



