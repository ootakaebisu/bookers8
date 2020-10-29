class BooksController < ApplicationController

  before_action :authenticate_user!

  def index
    @book = Book.new
    @books = Book.all
    @user = User.find(current_user.id)
  end

  def show
    @book = Book.new
    # 引数のparams[:id]とbook_paramsの違いってなんだ？
    @book_get = Book.find(params[:id])
    @user = User.find(@book_get.user_id)
  end

  def create
    # この20行目@user抜けがエラーの最後！要理解
    @user = User.find(current_user.id)
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "Book was successfully created."
      redirect_to book_path(@book)
    else
      # 【解決済】ここの記述わからん→保存できない時は絶対booksのindex飛ぶわ！納得
      @books = Book.all
      # renderってただ表示するだけだけどエラーメッセージは表示させられるのなんで？
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    correct_book(@book)
  end

  def update
    @book = Book.find(params[:id])
    # 引数間違えポイント
    if @book.update(book_params)
      flash[:notice] = "Book was successfully updated."
      redirect_to book_path(@book)
    else
      render :edit
    end
  end

  def destroy
    book = Book.find(params[:id])
    book.destroy
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body)
    end

    def correct_book(book)
      if current_user.id != book.user.id
        redirect_to books_path
      end
    end
end
