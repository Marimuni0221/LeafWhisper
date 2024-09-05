# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product do
  describe 'バリデーション' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:url_hash) }
    it { is_expected.to validate_uniqueness_of(:url_hash) }
  end

  describe 'コールバック' do
    it '保存前にurl_hashを生成する' do
      product = described_class.new(name: 'Test Product', item_url: 'http://example.com')
      product.save
      expect(product.url_hash).to be_present
    end
  end

  describe 'スコープ' do
    context 'when 価格が範囲内の場合' do
      let(:cheap_product) { create(:product, price: 300) }
      let(:expensive_product) { create(:product, price: 1500) }

      it '500円未満の商品のみを返す' do
        cheap_product
        expect(described_class.price_range('under_500').count).to eq(1)
      end

      it '500円から1000円の商品を返さない' do
        expensive_product
        expect(described_class.price_range('500_to_1000').count).to eq(0)
      end
    end
  end
end
