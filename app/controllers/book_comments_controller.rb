class BookCommentsController < ApplicationController

  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_to book_path(book)
  end

  def destroy
      # BookComment.find(params[:id]).destroy
      comment = BookComment.find(params[:id])
      if comment.user_id == current_user.id
        comment.destroy
        redirect_to request.referer
      else
        redirect_to book_path(comment.book)
      end
      # unless文で作成してものの読み込まれるが、削除も同時に実行される⇒redirect_toが2回読み込まれてエラーになる
      # unless comment.user_id == current_user.id
      #   redirect_to book_path(comment.book)
      # end
      # @comment = BookComment.find(params[:id])
      # @comment.destroy
      # redirect_to request.referer
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end


end
