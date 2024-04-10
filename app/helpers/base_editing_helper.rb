module BaseEditingHelper
  include Utilities::PageHelper
  include Utilities::EnumHelper
  include Utilities::SearchHelper


  ##
  # Genera le icone di Bootstrap icons
  def icon( name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "bi-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class
    html_options['aria-hidden'] ||= true

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end
end
