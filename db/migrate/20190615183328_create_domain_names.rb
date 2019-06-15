class CreateDomainNames < ActiveRecord::Migration
  def up
    create_table :domain_names do |t|
      t.string :domain_name, null: false
      t.integer :organization_id
    end
    
    add_index(:domain_names, :organization_id)
  end

  def down
    drop_table :domain_names
  end
end
