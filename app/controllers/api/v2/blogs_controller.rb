class Api::V2::BlogsController < ApplicationController
  before_action :set_blog, only: [:show_blog, :update_blog, :delete_blog]
  def index
    page = params[:page].to_i.positive? ? params[:page].to_i : 1
    per_page = params[:per_page].to_i.positive? ? params[:per_page].to_i : 10
    query_param = params[:query]
    @blogs = Blog.ransack(search_params(query_param)).result(distinct: true)
    begin
      pagy, @blogs = pagy(@blogs, items: per_page, page: page)
    rescue Pagy::OverflowError
      last_page = (@blogs.count / per_page.to_f).ceil
      pagy, @blogs = pagy(@blogs, items: per_page, page: last_page)
    end
    if @blogs.present?
      render json: {
        meta: { message: "Blogs listing are as follows" },
        blogs: ActiveModelSerializers::SerializableResource.new(@blogs, each_serializer: BlogSerializer)
      }, status: :ok
    else
      render json: { meta: { message: "No blogs found" } }, status: :ok
    end
  end

  def show_blog
    if @blog
      render json: {
        meta: { message: "Blog details" },
        blog: BlogSerializer.new(@blog).serializable_hash
      }, status: :ok
    end
  end

  def create
    @blog = Blog.new(blog_params)
    if @blog.save
      render json: { meta: { message: "Blog created successfully" }, data: BlogSerializer.new(@blog).serializable_hash }, status: :created
    else
      render json: { meta: { message: @blog.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  def update_blog
    if @blog.update(blog_params)
      render json: {
        meta: { message: "Blog updated successfully" },
        data: BlogSerializer.new(@blog).serializable_hash
      }, status: :ok
    else
      render json: { meta: { message: @blog.errors.full_messages } }, status: :unprocessable_entity
    end
  end

  def delete_blog
    if @blog
      @blog.destroy
      render json: { meta: { message: "Blog deleted successfully" } }, status: :ok
    else
      render json: { meta: { message: "Blog not found" } }, status: :not_found
    end
  end

  private

  def blog_params
    params.require(:blog).permit(:title, :category, :card_home_url, :card_insights_url, :banner_url, :body, :visibility, :publish_date, :publisher_id,
    :card_home_url_alt, :card_insights_url_alt, :banner_url_alt, :description, :path_name)
  end

  def set_blog
    @blog = Blog.find_by!(path_name: params[:path_name])
  rescue ActiveRecord::RecordNotFound
    render json: { meta: { message: "Blog not found" } }, status: :not_found
  end

  def search_params(query_param)
    fields_to_search = %w[ path_name ]
    search_conditions = fields_to_search.map do |field|
      { "#{field}_cont" => query_param }
    end

    if query_param.present?
      publishers = User.where('name ILIKE ? OR email ILIKE ?', "%#{query_param}%", "%#{query_param}%").pluck(:id)
      blogs = Blog.where(id: publishers).pluck(:path_name)
      search_conditions << { 'path_name_in' => blogs }
    end
    { 'combinator' => 'or', 'groupings' => search_conditions }
  end
end