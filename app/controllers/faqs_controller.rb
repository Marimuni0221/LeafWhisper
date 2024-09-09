# frozen_string_literal: true

class FaqsController < ApplicationController
  def index
    @faqs = faq_list
  end

  private

  def faq_list
    I18n.t('faqs.list')
  end
end
