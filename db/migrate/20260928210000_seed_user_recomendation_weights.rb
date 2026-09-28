class SeedUserRecomendationWeights < ActiveRecord::Migration[8.1]
  def up
    add_index :user_recomendation_weights, [ :user_id, :metric_name ], unique: true, name: "index_user_recomendation_weights_on_user_id_and_metric_name"

    execute <<~SQL
      INSERT INTO user_recomendation_weights (user_id, metric_name, weight, created_at, updated_at)
      SELECT u.id, metric.metric_name, metric.weight, NOW(), NOW()
      FROM users u
      CROSS JOIN (
        VALUES
          ('recency', 0.40),
          ('affinity', 0.20),
          ('social', 0.20),
          ('engagement', 0.20)
      ) AS metric(metric_name, weight)
      ON CONFLICT (user_id, metric_name) DO NOTHING;
    SQL
  end

  def down
    remove_index :user_recomendation_weights, name: "index_user_recomendation_weights_on_user_id_and_metric_name"
  end
end
