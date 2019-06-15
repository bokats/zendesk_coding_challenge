class CreateTags < ActiveRecord::Migration
  def up
    create_table :tags do |t|
      t.string :tag_name, null: false
      t.references :source, :polymorphic => true
    end

    add_index(:tags, :source_id)
  end

  def down
    drop_table :tags
  end
end
