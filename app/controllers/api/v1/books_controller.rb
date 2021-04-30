require 'net/http'

class Api::V1::BooksController < ApplicationController
  include ActionController::HttpAuthentication::Token

  MAX_PAGINATION_LIMIT = 100

  before_action :authenticate_user, only: [:create, :destroy]

  def index
    books = Book.limit(limit).offset(params[:offset])
    render json: BooksRepresenter.new(books).as_json
  end

  def show
    book = Book.find(params[:id])
    render json: BookRepresenter.new(book).as_json
  rescue ActiveRecord::RecordNotFound
      render json: {status: :not_found, message: "Please check for correct id."}
  end

  def create
    author = Author.create!(author_params)
    book = Book.new(book_params.merge(author_id: author.id))
    UpdateSkuJob.perform_later(book_params[:title])


    if book.save
      render json: BookRepresenter.new(book).as_json, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  def destroy 
    Book.find(params[:id]).destroy!

    head :no_content
  end

  private

  def limit 
    [params.fetch(:limit, MAX_PAGINATION_LIMIT).to_i, MAX_PAGINATION_LIMIT].min
  end

  def book_params
    params.require(:book).permit(:title)
  end

  def author_params 
    params.require(:author).permit(:first_name, :last_name, :age)
  end

  def authenticate_user
    # Authorization: Bearer <token>
    token, _options = token_and_options(request)
    user_id = AuthTokenService.decode(token)
    User.find( user_id )
  rescue ActiveRecord::RecordNotFound
    render status: :unauthorized
  end
end
