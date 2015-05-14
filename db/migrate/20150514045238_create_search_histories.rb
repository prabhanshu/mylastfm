class CreateSearchHistories < ActiveRecord::Migration
  def change
    create_table :search_histories do |t|
      t.references :user, index: true
      t.string :keyword

      t.timestamps null: false
    end
    add_foreign_key :search_histories, :users
  end
end
