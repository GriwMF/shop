class BooksController < ApplicationController
  before_filter :authenticate_customer!, except: [:index, :show]
  
  load_and_authorize_resource
  skip_load_resource only: [:index, :filter]

  # GET /books
  # GET /books.json
  def index
    @books = Book.all.includes(:ratings)
  end

  # GET /books/1
  # GET /books/1.json
  def show
    @book_ratings = @book.ratings.where(approved: "true").last(10)
  end

  # POST /books/1/rate
  def rate
    rating = @book.ratings.build(params.permit(:text, :rating))
    rating.customer = current_customer
    if rating.save
      flash[:info] = "Success! Please, wait for rating confirmation"
    else
      flash[:danger] = rating.errors
    end
    redirect_to root_path
  end
  
  # POST /books/1/add_wished
  def add_wished
    unless @book.wish_add(current_customer)
      flash[:danger] = "Already rated"
    else
      flash[:info] = "Successefully added"
    end
    redirect_to @book
  end
  
  # DELETE /books/1/wished
  def wished
    @book.wished_customers.delete(current_customer)
    redirect_to current_customer
  end
  
  # POST /books/filter
  def filter
    redirect_to root_path and return if params[:commit] == "Reset"
    
    @books = Book.filter(*prepare_filter).includes(:ratings)
    render "index"
  end
  
  private
    def prepare_filter
      filter_opts = params[:authors_id], params[:categories_id], params[:books_id]
      filter_opts.each { |item| item.shift }
      filter_opts
    end
end
