# require "pretty_slugs/version"
require 'active_support/concern'
require 'active_record'

module PrettySlugs
  extend ActiveSupport::Concern
  included do
    attr_accessible :slug
    
    after_commit lambda {
      action = transaction_include_action?(:create) ? "create" : transaction_include_action?(:destroy) ? "destroy" : "save"
      case action
      when "destroy"
        remove_slug
      when "create"
        check_slug_existence
      when "save"
        check_slug_existence
      end
    }
    
    # Class method overload for ActiveRecord's find.  Covers id's passed in as string or number, and slugs passed.
    # This is wrapped in an eval block because of Ruby 1.9.2 and issues with super in a singleton included by multiple classes. 
    # This is the error otherwise:
    # super from singleton method that is defined to multiple classes is not supported; this will be fixed in 1.9.3 or later
    # http://stackoverflow.com/questions/4261615/workaround-for-ruby-1-9-2-super-from-singleton-method-that-is-defined-to-multip
    # error occurs when same lexical method (which calls super) is defined on the singleton class of two or more objects of different classes, and then that method is called on any of the objects other than the last one the method was defined on...
    eval %(
      def self.find(input, *args)
        if input.is_a?(Integer) || input.is_a?(Fixnum)
          super
        elsif input.is_a?(Symbol)
          super
        elsif input.is_a?(String) && input.to_i.to_s == input
          super
        else
          obj = Slug.find_by_slug(input)
          return obj.sluggable_class.constantize.find(obj.sluggable_id, args) rescue nil
        end
      end
    )
    class Slug < ActiveRecord::Base
      self.table_name = 'pretty_slugs'
      attr_accessible :slug, :sluggable_id, :sluggable_class
    end
    
    def slug
      return '' if self.new_record?
      slug = Slug.find_by_sluggable_id_and_sluggable_class(self.id, self.class.to_s).slug rescue nil
      return slug if slug
      generate_slug
    end
    
    def slug=(val)
      # the function of to_slug(val) means that if I try to store a 
      # custom slug, it will make sure it is slug-worthy, lowercase, underscored, etc...
      @slugstorage = to_slug(val) and return if self.new_record?
      check_slug_existence
      if val != nil && val != ""
        slug = val
        Slug.find_by_sluggable_id_and_sluggable_class(self.id, self.class.to_s).update_attribute(:slug, val)
        update_menu_elements(val)
      else
        # do nothing
      end
    end
    
    def check_slug_existence
      if self.slug.nil?
        generate_slug
      end
    end
    
    def generate_slug
      inc = 1
      slug = self.to_slug
      while !Slug.find_by_slug_and_sluggable_class(slug, self.class.to_s).nil?
        slug += "-#{inc}"
        inc += 1
      end

      obj = Slug.create({
        slug: slug,
        sluggable_id: self.id,
        sluggable_class: self.class.to_s
      })
      
      update_menu_elements(slug)
      slug
    end
    
    def remove_slug
      Slug.find_by_sluggable_id_and_sluggable_class(self.id, self.class.to_s).destroy rescue true
    end
    
    def update_slug
      Slug.find_by_sluggable_id_and_sluggable_class(self.id, self.class.to_s).update_attribute(slug: self.slug)
    end
    
    def update_menu_elements(url=nil)
      if self.respond_to?("menu_elements") && self.class.to_s == "Page"
        self.menu_elements.each{|me| me.update_attribute(:url, ("/pages/" + (url.nil? || url.empty? ? self.slug : url)))}
      end
    end
    
    def to_slug(val=nil)
      return @slugstorage if @slugstorage 
      word = self[self.respond_to?("name") ? "name" : "title"] rescue self["id"]
      word = self["id"].to_s if word.nil?

      #strip the string
      ret = val.nil? ? word.strip : val 
      ret = ret.downcase
      #blow away apostrophes
      ret.gsub! /['`]/,""

      # @ --> at, and & --> and
      ret.gsub! /\s*@\s*/, " at "
      ret.gsub! /\s*&\s*/, " and "

      #replace all non alphanumeric, underscore or periods with underscore
      ret.gsub! /\s*[^A-Za-z0-9\.\-]\s*/, '_'  

      #convert double underscores to single
      ret.gsub! /_+/,"_"

      #strip off leading/trailing underscore
      ret.gsub! /\A[_\.]+|[_\.]+\z/,""

      ret
    end
  end
end
