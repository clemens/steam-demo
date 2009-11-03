class CreateTasks < ActiveRecord::Migration
  def self.up
    create_table :tasks do |t|
      t.belongs_to :list
      t.integer :position
      t.string :name
      t.boolean :done

      t.timestamps
    end
  end

  def self.down
    drop_table :tasks
  end
end
