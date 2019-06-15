class CreateOrganizations < ActiveRecord::Migration
  def up
    create_table :organizations do |t|
      t.string :url
      t.string :external_id
      t.string :name
      t.string :details
      t.boolean :shared_tickets, default: false
      t.string :created_at
    end
  end

  def down
    drop_table :organizations
  end
end
