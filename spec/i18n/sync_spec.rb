# -*- coding: utf-8 -*-
require 'spec_helper'
require 'fileutils'

EN = "spec/tmp/work/en.yml"

def result(name)
  File.read("spec/results/#{name}.yml")
end

def work(params, options = {})
  I18n::Sync::Work.new("#{File.dirname(__FILE__)}/../tmp/#{params}", options).sync
end

def files_should_match(name, extra = nil)
  expect(File.read("spec/tmp#{extra}/#{name}.yml")).to eql(result(name))
end

describe "I18n Sync" do

  before do
    FileUtils.rm_rf 'spec/tmp'
    # FileUtils.mkdir 'spec/tmp'
    FileUtils.cp_r 'spec/fixtures', 'spec/tmp'
  end

  describe "Acceptance" do

    it 'should sync files nicely (unprefixed)' do
      work("pt.yml")
      expect(File.read(EN)).to eql("\n--- \nen: \n  new: \"Uau, isso é novo\"\n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should respect namespaces" do
      work("spec/tmp/work/pt.yml")
      expect(File.read("spec/tmp/named.pt.yml")).to eql("\npt:\n  something: Algo\n")
    end

    it "should work with namespaces" do
      work("spec/tmp/work/named.en.yml")
      files_should_match("named.pt")
      expect(File.read("spec/tmp/work/pt.yml")).to
         eql("\npt:\n  sync: To Sync It!\n  test: Teste\n  new: \"Uau, isso é novo\"\n")
    end

    it "should order alphabeticaly namespaces" do
      work("spec/tmp/work/order.pt.yml")
      files_should_match("order.en")
      File.read("spec/tmp/work/named.pt.yml").to eql("\npt:\n  something: Algo\n")
    end

    it "should work with extra chars" do
      work("spec/tmp/work/extra.en.yml")
      files_should_match("extra.pt")
    end

    it "should work with deep nestings" do
      work("spec/tmp/work/children.en.yml")
      files_should_match("children.pt")
    end

  end

  describe "Creating files" do

    it "should create a new one" do
      newfile = "spec/tmp/work/fo.yml"; `rm #{newfile}` if File.exists?(newfile)
      work("#{EN} fo")
      expect(File.read(newfile)).to eql("# Comment cool\n--- \nfo: \n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should create a new with the right name" do
      newfile = "spec/tmp/work/named.fo.yml"; `rm #{newfile}` if File.exists?(newfile)
      work("named.en.yml fo")
      expect(File.read(newfile)).to eql("\n--- \nfo: \n  another: Another\n  something: Something\n")
    end

  end

  it 'should sync a multiple nicely' do
    work("extra.pt")
    files_should_match("extra.pt", :multi)
  end

  it 'should sync a whole directory' do
    pending
    work("spec/tmp/workmulti")
    files_should_match("extra.pt", :multi)
  end


  # describe "Add keys to i18n!" do

  #   it "should have a nice command to add stuff" do
  #     work("add dynamic Dynamic spec/tmp/work/en.yml")
  #     expect(File.read("spec/tmp/work/en.yml")).to eql("# Comment cool\n--- \nen: \n  dynamic: Dynamic\n  sync: \"To Sync It!\"\n  test: Test\n")
  #   end

  #   it "should work on a complex scenario" do
  #     work("add dynamic.nested.very.nasty Nasty spec/tmp/work/extra.en.yml")
  #     expect(File.read("spec/tmp/work/extra.en.yml")).to eql("\n--- \nen: \n  dynamic: \n    nested: \n      very: \n        nasty: Nasty\n  normal: Normal\n  with_colon: \"Value: Rock\"\n  yup: true\n")

  #   end
  # end

end
