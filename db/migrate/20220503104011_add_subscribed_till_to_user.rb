class AddSubscribedTillToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscribed_till, :datetime
  end
end
