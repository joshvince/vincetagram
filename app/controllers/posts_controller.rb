# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :require_user!, except: %i[show]
  before_action :set_post, only: %i[show edit update destroy feed_post]

  # GET /feed
  def feed
    @post_ids = Post.all.order(created_at: :desc).select(:id)
  end

  def feed_post
    # This is just to add a delay to show the loading indicator otherwise things were too fast
    sleep(0.2.seconds)
  end

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show; end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts or /posts.json
  def create
    @post = Post.new(post_params.merge(user: current_user))

    if @post.save
      @post.sync_file_to_archive
      redirect_to feed_path, notice: 'Post was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    if @post.update(post_params)
      redirect_to post_url(@post), notice: 'Post was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy

    redirect_to posts_url, notice: 'Post was successfully destroyed.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:caption, :photo, :video)
  end
end
