require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:current_user) { create(:user) }

  before do
    request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(user_id: current_user.id)}"
  end

  describe 'POST #create' do
    it 'cria um post para o usuário autenticado' do
      expect do
        post :create, params: { post: { content: 'Olá mundo' } }, as: :json
      end.to change(Post, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['content']).to eq('Olá mundo')
      expect(Post.last.user).to eq(current_user)
    end
  end

  describe 'GET #following' do
    it 'carrega os posts dos usuários que o usuário atual segue' do
      followed_user = create(:user)
      followed_post = create(:post, user: followed_user, content: 'Post do seguido')
      create(:follow, follower: current_user, followed: followed_user)

      get :following, as: :json

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).map { |post| post['content'] }).to include('Post do seguido')
      expect(JSON.parse(response.body).any? { |post| post['id'] == followed_post.id }).to be(true)
    end
  end
end
