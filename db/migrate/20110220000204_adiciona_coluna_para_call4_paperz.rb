class AdicionaColunaParaCall4Paperz < ActiveRecord::Migration
  def self.up
      add_column :eventos, :call_4_paperz_id, :integer, :default => nil
  end

  def self.down
      remove_column :eventos, :call_4_paperz_id
  end
end
