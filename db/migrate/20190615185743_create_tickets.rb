class CreateTickets < ActiveRecord::Migration
  def up
    create_table :tickets do |t|
      t.string :_id, null: false
      t.string :url
      t.string :external_id
      t.string :created_at
      t.string :type
      t.string :subject
      t.text :description
      t.string :priority
      t.string :status
      t.integer :submitter_id
      t.integer :assignee_id
      t.integer :organization_id
      t.boolean :has_incidents, default: false
      t.string :due_at
      t.string :via
    end

    add_index(:tickets, :submitter_id)
    add_index(:tickets, :assignee_id)
    add_index(:tickets, :organization_id)
  end

  def down
    drop_table :tickets
  end
end
