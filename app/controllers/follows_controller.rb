class FollowsController < ApplicationController
  def create
    user_to_follow = User.find(params[:id])

    if @current_user.following.include?(user_to_follow)
      render json: { error: "You are already following this user." }, status: :unprocessable_entity
      return
    end

    @current_user.following << user_to_follow

    if @current_user.save
      render json: { message: "Successfully followed the user." }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    user_to_unfollow = User.find(params[:id])

    unless @current_user.following.include?(user_to_unfollow)
      render json: { error: "You are not following this user." }, status: :unprocessable_entity
      return
    end

    @current_user.following.delete(user_to_unfollow)

    if @current_user.save
      render json: { message: "Successfully unfollowed the user." }, status: :ok
    else
      render json: { errors: @current_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def follow_params
    params.permit(:id)
  end
end
