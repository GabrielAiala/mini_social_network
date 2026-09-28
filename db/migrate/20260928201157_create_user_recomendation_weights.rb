class CreateUserRecomendationWeights < ActiveRecord::Migration[8.1]
  def change
    create_table :user_recomendation_weights do |t|
      t.string :metric_name, null: false
      t.float :weight, null: false, precision: 10, scale: 2
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
