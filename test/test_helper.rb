require 'rubygems'

require "minitest/matchers"
require 'minitest/autorun'
require 'minitest/pride'
require File.expand_path('../../lib/pretty_slugs.rb', __FILE__)

ActiveRecord::Base.establish_connection(:adapter => "sqlite3", 
                                       :database => ':memory:')

ActiveRecord::Schema.define do
  self.verbose = false

  create_table :pages, :force => true do |t|
    t.string :name
    t.string :title
    t.string :body
  end

  create_table :pretty_slugs, :force => true do |t|
    t.string :slug, null: false
    t.integer :sluggable_id, null: false
    t.string :sluggable_class, null: false
    t.timestamps
  end
  
  add_index :pretty_slugs, :sluggable_id
  add_index :pretty_slugs, [:slug, :sluggable_class]
  add_index :pretty_slugs, :sluggable_class
  
end
