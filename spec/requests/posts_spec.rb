require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:user) { create(:user) }
  let(:token) { JsonWebToken.encode(user_id: user.id) }

  describe 'POST /posts' do
    it 'cria um post para o usuário autenticado' do
      post '/posts', params: { post: { content: 'Olá mundo' } }, headers: { 'Authorization' => "Bearer #{token}" }, as: :json

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['content']).to eq('Olá mundo')
      expect(Post.last.user).to eq(user)
    end
  end

  describe 'GET /posts/following' do
    it 'retorna os posts dos usuários que o usuário atual segue' do
      followed_user = create(:user)
      followed_post = create(:post, user: followed_user, content: 'Post do seguido')
      create(:follow, follower: user, followed: followed_user)

      get '/posts/following', headers: { 'Authorization' => "Bearer #{token}" }, as: :json

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['posts'].map { |post| post['content'] }).to include('Post do seguido')
      expect(json['posts'].any? { |post| post['id'] == followed_post.id }).to be(true)
      expect(json).to have_key('pagination')
    end
  end
end
