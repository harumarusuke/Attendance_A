class AddAdminToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :admin, :boolean, default: false #boolean型は末尾を？にすると値を取得できる
  end
end
