require 'rails/generators'
require 'rails/generators/active_record'

class PrettySlugsGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration
  
  source_root File.expand_path("../../pretty_slugs", __FILE__)
  
  def copy_files(*args)
    migration_template "migration.rb", "db/migrate/create_pretty_slugs.rb"
  end
end