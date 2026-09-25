require 'rails_helper'

RSpec.describe LikesController, type: :controller do
  let(:current_user) { create(:user) }
  let(:post_item) { create(:post) }

  before do
    request.headers['Authorization'] = "Bearer #{JsonWebToken.encode(user_id: current_user.id)}"
  end

  describe 'POST #create' do
    it 'cria uma curtida para o usuário autenticado' do
      expect do
        post :create, params: { like: { post_id: post_item.id } }, as: :json
      end.to change(Like, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['post_id']).to eq(post_item.id)
      expect(Like.last.user).to eq(current_user)
    end

    it 'remove a curtida quando ela já existe' do
      create(:like, user: current_user, post: post_item)

      expect do
        post :create, params: { like: { post_id: post_item.id } }, as: :json
      end.to change(Like, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Like removido com sucesso')
    end
  end
end
