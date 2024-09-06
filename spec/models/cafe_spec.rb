# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Cafe do
  let(:cafe) { create(:cafe) }

  it 'テーブル名が正しい' do
    expect(described_class.table_name).to eq('caves')
  end

  it '複数のお気に入りを所持' do
    expect(cafe).to have_many(:favorites).dependent(:destroy)
  end
end
