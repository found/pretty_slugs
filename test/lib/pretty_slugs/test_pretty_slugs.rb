require_relative '../../test_helper'
require 'active_record'

class Page < ActiveRecord::Base
  include PrettySlugs
  attr_accessible :name, :title, :body
end


describe PrettySlugs do

  before do
    Page.destroy_all
    PrettySlugs::Slug.destroy_all
    @tim = Page.new(:name => "Timothy Johnson", :title => "Rails Peanut", :body => "Tim is a poser")
    @timothy = Page.new(:name => "Timothy Johnson", :title => "Poop", :body => "sdfsf sd")
    @joe = Page.new(:name => "Joe Ruoto", :slug => "joey_r", :title => "the man")
  end

  it "must be defined" do
    PrettySlugs.wont_be_nil
  end

  it "must have a Page" do
    Page.wont_be_nil
  end


  it "Page and Active Record save and retrieval work correctly" do
    @tim.save
    Page.first.name.must_equal "Timothy Johnson"
  end

  it "must create a slug on saving the parent model" do
    @tim.save
    Page.find("timothy_johnson").must_equal @tim
  end

  it "must create a slug on a saved Page" do
    @tim.save
    @tim.slug.must_equal "timothy_johnson"
    Page.find("timothy_johnson").must_equal @tim
  end

  it "must not create a slug on non-saved Page" do
    @tim.slug.must_equal ''
  end

  it "must create a new slug when a previous one is similar" do
    @tim.save
    @timothy.save
    @tim.slug.must_equal 'timothy_johnson'
    @timothy.slug.must_equal 'timothy_johnson-1'
    Page.find("timothy_johnson").must_equal @tim
    Page.find("timothy_johnson-1").must_equal @timothy
  end

  it "must assign a manual slug correctly" do
    @joe.save
    @joe.slug.must_equal "joey_r"
    Page.find("joey_r").must_equal @joe
  end

  it "must assign a manual slug after saving correctly" do
    @joe.save
    @joe.slug = "jimminy"
    @joe.save
    @joe.slug.must_equal "jimminy"
    Page.find("jimminy").must_equal @joe
  end

  it "must automatically create a slug, and allow overriding" do 
    @tim.save
    Page.find("timothy_johnson").must_equal @tim
    @tim.slug = "timmy"
    @tim.save
    Page.find("timothy_johnson").must_be_nil
    Page.find("timmy").must_equal @tim
  end

  it "must handle case-sensitive slugs just like matching slugs" do
    @jon = Page.new(:name => "Jon Teimann", :slug => "jon")
    @jont = Page.new(:name => "Jon Teimann", :slug => "Jon")
    @jon.save
    @jont.save
    Page.find("jon").must_equal @jon
    Page.find("jon-1").must_equal @jont
    @jont.slug.must_equal "jon-1"
  end

end
