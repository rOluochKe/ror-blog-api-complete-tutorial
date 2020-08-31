class ArticlesController < ApplicationController
  skip_before_action :authorize!, only: %i[index show]

  def index
    articles = Article.recent
      .page(current_page)
      .per(per_page)
    render json: articles
  end

  def show
    render json: Article.find(params[:id])
  end

  def create
    article = current_user.articles.build(article_params)
    article.save!
    render json: article, status: :created
  rescue StandardError
    render json: article, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  def update
    article = current_user.articles.find(params[:id])
    article.update_attributes!(article_params)
    render json: article, status: :ok
  rescue ActiveRecord::RecordNotFound
    authorization_error
  rescue StandardError
    render json: article, adapter: :json_api,
           serializer: ErrorSerializer,
           status: :unprocessable_entity
  end

  def destroy
    article = current_user.articles.find(params[:id])
    article.destroy
    head :no_content
  rescue StandardError
    authorization_error
  end

  private

  def article_params
    params.require(:data).require(:attributes)
      .permit(:title, :content, :slug) ||
      ActionController::Parameters.new
  end
end
