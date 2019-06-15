class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :url
      t.string :external_id
      t.string :name
      t.string :alias
      t.string :created_at
      t.boolean :active, default: true
      t.boolean :verified, default: true
      t.boolean :shared, default: false
      t.string :locale
      t.string :timezone
      t.string :last_login_at
      t.string :email
      t.string :phone
      t.string :signature
      t.integer :organization_id
      t.boolean :suspended, default: false
      t.string :role
    end

    add_index(:users, :organization_id)
  end

  def down
    drop_table :users
  end
end
