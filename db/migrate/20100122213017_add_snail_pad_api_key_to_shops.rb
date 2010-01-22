class AddSnailPadApiKeyToShops < ActiveRecord::Migration
  def self.up
    add_column :shops, :snailpad_api_key, :string
  end

  def self.down
    remove_column :shops, :snailpad_api_key
  end
end
