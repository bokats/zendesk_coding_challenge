class AddUtfSupport < ActiveRecord::Migration
  def up
    execute "ALTER DATABASE #{connection.current_database} CHARACTER SET 'utf8' COLLATE 'utf8_unicode_ci'"
  end

  def connection
    ActiveRecord::Base.connection
  end
end
