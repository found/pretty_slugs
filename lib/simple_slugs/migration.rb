class CreateSimpleSlugs < ActiveRecord::Migration
  def self.up
    create_table :simple_slugs do |t|
      t.string :slug, null: false
      t.integer :sluggable_id, null: false
      t.string :sluggable_class, null: false
      t.timestamps
    end
    
    add_index :simple_slugs, :sluggable_id
    add_index :simple_slugs, [:slug, :sluggable_class]
    add_index :simple_slugs, :sluggable_class
  end
  
  def self.down
    drop_table :friendly_id_slugs
  end
end