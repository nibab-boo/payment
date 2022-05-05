class CreateSubscriptions < ActiveRecord::Migration[6.1]
  def change
    create_table :subscriptions do |t|
      t.string :plan_id
      t.string :customer_id
      t.references :user, null: false
      t.string :status
      t.string :interval
      t.string :subscription_id
      t.datetime :current_period_start
      t.datetime :current_period_end

      t.timestamps
    end
  end
end
