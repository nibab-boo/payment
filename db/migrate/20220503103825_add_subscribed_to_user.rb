class AddSubscribedToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :subscripted, :string, default: "free"
  end
end
