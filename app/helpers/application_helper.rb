# frozen_string_literal: true

module ApplicationHelper
  def page_title(title = '')
    base_title = 'LeafWhisper'
    title.present? ? "#{title} | #{base_title}" : base_title
  end

  def turbo_stream_flash
    turbo_stream.update 'flash', partial: 'shared/flash_message'
  end

  def favorites_page?
    request.referer == favorites_url
  end

  def share_on_x_url(object)
    url = extract_url(object)
    text = generate_share_text(object)
    encoded_text = CGI.escape(text || I18n.t('share.default_text'))

    "https://twitter.com/share?url=#{url}&text=#{encoded_text}"
  end

  private

  def extract_url(object)
    case object
    when Product
      object.item_url || 'https://default-url.com'
    when Cafe
      object.cafe_url || 'https://default-url.com'
    else
      'https://default-url.com'
    end
  end

  def generate_share_text(object)
    case object
    when Product
      I18n.t('share.product', default: 'おすすめの抹茶の商品を見つけました！ #抹茶 #日本茶 #LeafWhisper')
    when Cafe
      I18n.t('share.cafe', name: object.name,
                           default: "#{object.name} に行ってきました！すごくおすすめのカフェです。 #抹茶カフェ #日本茶 #LeafWhisper")
    else
      I18n.t('share.default', default: '素晴らしいアイテムやカフェをチェックしてみてください！ #LeafWhisper')
    end
  end
end
