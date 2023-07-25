class CreatePushSubscriptions < ActiveRecord::Migration[7.0]
  def change
    create_table :push_subscriptions, id: :uuid do |t|
      t.jsonb :blob
      t.belongs_to :user, null: false, foreign_key: true, type: :uuid

      t.timestamps
    end
  end
end
