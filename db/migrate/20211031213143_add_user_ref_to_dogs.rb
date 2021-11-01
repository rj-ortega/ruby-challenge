class AddUserRefToDogs < ActiveRecord::Migration[5.2]
  def change
    add_reference :dogs, :user
  end
end
