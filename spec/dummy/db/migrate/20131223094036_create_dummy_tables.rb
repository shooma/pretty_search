class CreateDummyTables < ActiveRecord::Migration
  def up
    create_table(:companies) { |t| t.string :title }
    create_table(:mugs) { |t| t.integer :volume }
  end

  def down
    drop_table :companies
    drop_table :mugs
  end
end
