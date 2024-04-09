# frozen_string_literal: true

module Utilities::ModalHelper
  ##
  # Metodo speciale per l'inclusione del contenuto nelle modal, forzando il flush in modo da poter utilizzare
  # più modal contemporaneamente
  def content_for_modal(*args, &block)
    opts = args.extract_options!
    content_for(*args, opts.merge(flush: true), &block)
  end
end
