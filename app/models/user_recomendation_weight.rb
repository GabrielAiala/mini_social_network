class UserRecomendationWeight < ApplicationRecord
  belongs_to :user

  validates :metric_name, presence: true, inclusion: { in: %w[recency affinity social engagement] }
  validates :weight, presence: true, numericality: true
  validates :user_id, uniqueness: { scope: :metric_name }
end
