class PostsController < ApplicationController
  def create
    @post = Post.new(post_params)
    @post.user = @current_user

    if @post.save
      render json: @post, status: :created
    else
      render json: { errors: @post.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def following
    followed_user_ids = @current_user.following.pluck(:id) + [ @current_user.id ]

    posts = Post
      .where(user_id: followed_user_ids)
      .joins(:user)
      .left_joins(:likes)
      .select(<<~SQL)
        posts.*,
        users.name AS user_name,
        COUNT(likes.id) AS likes_count,
        MAX(CASE WHEN likes.user_id = #{@current_user.id} THEN 1 ELSE 0 END) AS liked
      SQL
      .group("posts.id, users.id, users.name")
      .order("posts.created_at DESC")

    @pagy, @posts = pagy(posts)
    render json: {
      posts: @posts,
      pagination: pagy_metadata(@pagy)
    }
  end

  def posts_by_user
    user_id = params[:user_id] || params[:id]
    user = User.find(user_id)

    posts = Post
      .where(user: user)
      .joins(:user)
      .left_joins(:likes)
      .select(<<~SQL)
        posts.*,
        users.name AS user_name,
        COUNT(likes.id) AS likes_count,
        MAX(CASE WHEN likes.user_id = #{@current_user.id} THEN 1 ELSE 0 END) AS liked
      SQL
      .group("posts.id, users.id, users.name")
      .order("posts.created_at DESC")

    @pagy, @posts = pagy(posts)
    render json: {
      posts: @posts,
      pagination: pagy_metadata(@pagy)
    }
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end
end
