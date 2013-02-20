require 'rails/generators'
require 'rails/generators/active_record'

class SimpleSlugsGenerator < Rails::Generators::Base
  include Rails::Generators::Migration
  extend ActiveRecord::Generators::Migration
  
  source_root File.expand_path("../../simple_slug", __FILE__)
  
  def copy_files(*args)
    migration_template "migration.rb", "db/migrate/create_simple_slugs.rb"
  end
end