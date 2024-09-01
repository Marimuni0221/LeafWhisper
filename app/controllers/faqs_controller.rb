# frozen_string_literal: true

class FaqsController < ApplicationController
  def index
    @faqs = [
      { question: I18n.t('faqs.questions.what_is_matcha'),
        answer: I18n.t('faqs.answers.what_is_matcha') },
      { question: I18n.t('faqs.questions.matcha_health_benefits'),
        answer: I18n.t('faqs.answers.matcha_health_benefits') },
      { question: I18n.t('faqs.questions.how_to_prepare_matcha'),
        answer: I18n.t('faqs.answers.how_to_prepare_matcha') },
      { question: I18n.t('faqs.questions.how_to_store_matcha'),
        answer: I18n.t('faqs.answers.how_to_store_matcha') },
      { question: I18n.t('faqs.questions.difference_matcha_and_green_tea'),
        answer: I18n.t('faqs.answers.difference_matcha_and_green_tea') },
      { question: I18n.t('faqs.questions.types_of_matcha'),
        answer: I18n.t('faqs.answers.types_of_matcha') },
      { question: I18n.t('faqs.questions.caffeine_in_matcha'),
        answer: I18n.t('faqs.answers.caffeine_in_matcha') },
      { question: I18n.t('faqs.questions.matcha_for_diet'),
        answer: I18n.t('faqs.answers.matcha_for_diet') },
      { question: I18n.t('faqs.questions.popular_matcha_recipes'),
        answer: I18n.t('faqs.answers.popular_matcha_recipes') },
      { question: I18n.t('faqs.questions.how_to_choose_matcha'),
        answer: I18n.t('faqs.answers.how_to_choose_matcha') },
      { question: I18n.t('faqs.questions.can_kids_drink_matcha'),
        answer: I18n.t('faqs.answers.can_kids_drink_matcha') },
      { question: I18n.t('faqs.questions.matcha_for_vegans'),
        answer: I18n.t('faqs.answers.matcha_for_vegans') }
    ]
  end
end
