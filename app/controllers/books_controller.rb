class BooksController < ApplicationController
	before_action :find_book, only: [:show, :edit, :update, :destroy]
	
	def index
		if params[:category].blank?
			@book = Book.all.order("created_at DESC")
		else
			@category_id = Category.find_by(name: params[:category]).id
			@book = Book.where(:category_id => @category_id).order("created_at DESC")
		end
		# @books = Book.all
		# render json: Book.all[0]
	end

	def show
		# byebug
	end

	def new
		# @book = Book.new
		@book = current_user.books.build
		@categories = Category.all.map{ |c| [c.name, c.id]}
	end

	def create
		# @book = Book.new(book_params)
		@book = current_user.books.build(book_params)
		@book.category_id = params[:category_id]
		if @book.save
			redirect_to root_path
		else render 'new'
		end
	end

	def edit
		@categories = Category.all.map{ |c| [c.name, c.id]}
	end

	def update
		@book.category_id = params[:category_id]
		if @book.update(book_params)
			redirect_to book_path(@book)
		else 
			render 'edit'
		end
	end

	def destroy
		@book.destroy
		redirect_to root_path
	end

	private

		def book_params
			params.require(:book).permit(:title, :description, :author, :category_id, :book_img)
		end

		def find_book
			@book = Book.find(params[:id])
		end
end
