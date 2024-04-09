module BaseEditingHelper
  include Utilities::PageHelper
  include Utilities::EnumHelper
  include Utilities::SearchHelper
  include Utilities::FormHelper


  ##
  # Genera le icone per font-awesome.
  # Spudoratamente copiato da https://github.com/FortAwesome/font-awesome-sass/blob/master/lib/font_awesome/sass/rails/helpers.rb
  # ma non volevo avere una dipendenza in più
  def icon(style, name, text = nil, html_options = {})
    text, html_options = nil, text if text.is_a?(Hash)

    content_class = "#{style} fa-#{name}"
    content_class << " #{html_options[:class]}" if html_options.key?(:class)
    html_options[:class] = content_class
    html_options['aria-hidden'] ||= true

    html = content_tag(:i, nil, html_options)
    html << ' ' << text.to_s unless text.blank?
    html
  end
end
