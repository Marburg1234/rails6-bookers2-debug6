class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = @book.user

    #ページを訪問した人を記録する
    user = current_user
    #自分の投稿を訪問しても増えないようにする
    if user != @user
      user.visit_counts.create(book_id: @book.id)
    end
  end

  def index
    # @books = Book.all
    @books = Book.left_joins(:favorites).group(:id).order('COUNT(favorites.id) DESC').all
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    unless current_user.id == @book.user.id
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.delete
    redirect_to books_path
  end




  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
