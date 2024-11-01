class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def update
    notification = current_user.notifications.find(params[:id])
    notification.update(read: true)
    # 通知の種類によるリダイレクトパスの生成
    case notification.notifiable_type
    when "Book"
      # 投稿通知を押したときのリダイレクト先
      redirect_to book_path(notification.notifiable)
    else
      # いいねされた通知のリダイレクト先(いいねしてくれたユーザーshowページへ遷移するに設定されている)
      # redirect_to user_path(notification.notifiable.user)

      # リダイレクト先をいいねしてくれた本の詳細ページへ変更
      redirect_to book_path(notification.notifiable.book)
    end
  end


end
