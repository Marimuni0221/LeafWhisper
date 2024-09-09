# frozen_string_literal: true

class ContactsController < ApplicationController
  def new
    @contact = Contact.new
  end

  def create
    @contact = Contact.new(contact_params)

    if @contact.valid?
      # メールを送信
      send_contact_email
      # 成功メッセージとともにリダイレクト
      redirect_to new_contact_path, notice: I18n.t('contacts.notices.sent')
    else
      # バリデーションエラーがある場合、再度フォームを表示（エラーメッセージは自動的に @contact.errors に格納される）
      render :new, status: :unprocessable_entity
    end
  end

  private

  # パラメータのストロングパラメータ設定
  def contact_params
    params.require(:contact).permit(:name, :email, :message)
  end

  def send_contact_email
    ContactMailer.send_contact_email(
      @contact.name,
      @contact.email,
      @contact.message
    ).deliver_now
  end
end
