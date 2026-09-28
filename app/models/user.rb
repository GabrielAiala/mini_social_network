class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true

  has_many :posts, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_posts, through: :likes, source: :post

  has_many :active_follows, class_name: "Follow", foreign_key: :follower_id, dependent: :destroy
  has_many :following, through: :active_follows, source: :followed

  has_many :passive_follows, class_name: "Follow", foreign_key: :followed_id, dependent: :destroy
  has_many :followers, through: :passive_follows, source: :follower

  has_many :recommendation_weights, class_name: "UserRecomendationWeight", dependent: :destroy

  after_commit :create_default_recommendation_weights, on: :create

  private

  def create_default_recommendation_weights
    default_weights = {
      "recency" => 0.40,
      "affinity" => 0.20,
      "social" => 0.20,
      "engagement" => 0.20
    }

    default_weights.each do |metric_name, weight|
      recommendation_weights.create!(metric_name: metric_name, weight: weight)
    end
  end
end
