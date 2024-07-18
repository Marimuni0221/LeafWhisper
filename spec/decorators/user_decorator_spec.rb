require 'rails_helper'

RSpec.describe UserDecorator do
  let(:user) { create(:user) }

  describe 'ニックネームをヘッダーに表示する' do
    context 'ユーザーがニックネームを持っている時' do
      it 'ニックネームを表示' do
        user.name = "John Doe"
        expect(user.decorate.display_name).to eq "John Doe"
      end
    end

    context 'ユーザーがニックネームを持っていない時' do
      it '"匿名ユーザー"を表示' do
        user.name = nil
        expect(user.decorate.display_name).to eq "匿名ユーザー"
      end
    end
  end
end
