# -*- coding: utf-8 -*-
require 'spec_helper'

EN = "spec/tmp/work/en.yml"

def result(name)
  File.read("spec/results/#{name}.yml")
end

def files_should_match(name, extra = nil)
  expect(File.read("spec/tmp/work#{extra}/#{name}.yml")).to eql(result(name))
end

describe "I18n Sync" do
  before do
    FileUtils.rm_rf 'spec/tmp'
    FileUtils.mkdir 'spec/tmp'
    FileUtils.cp_r 'spec/fixtures', 'spec/tmp'
  end

  describe "Unit" do

    let(:i) { I18S.new("spec/tmp/work/en.yml") }

    it "should parse master file" do
      expect(i.instance_variable_get("@path")).to eql("spec/tmp/work")
      expect(i.instance_variable_get("@lang")).to eql("en")
      expect(i.instance_variable_get("@file")).to eql("en.yml")
    end

    it "should read comments" do
      expect(i.instance_variable_get("@comments")).to eql("# Comment cool\n")
    end

    it "should read the hash" do
      expect(i.instance_variable_get("@words")).to eql({"sync"=>"To Sync It!", "test"=>"Test"})
    end

    it "should work fine with other files" do
      i2 = I18S.new("spec/tmp/work/pt.yml")
      expect(i2.instance_variable_get("@lang")).to eql("pt")
      expect(i2.instance_variable_get("@comments")).to be_empty
    end

  end

  describe "Namespaced" do

    let(:i) { I18S.new("spec/tmp/work/named.en.yml") }

    it "should parse master file" do
      expect(i.instance_variable_get("@path")).to eql("spec/tmp/work")
      expect(i.instance_variable_get("@lang")).to eql("en")
      expect(i.instance_variable_get("@namespace")).to eql("named")
      expect(i.instance_variable_get("@file")).to eql("named.en.yml")
    end

    it "should read the hash" do
      expect(i.instance_variable_get("@words")).
         to eql({"something"=>"Something", "another"=>"Another"})
    end

  end

  describe "Acceptance" do

    it "should sync files nicely" do
      run("spec/tmp/work/pt.yml")
      expect(File.read(EN)).to eql("\n--- \nen: \n  new: \"Uau, isso é novo\"\n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should respect namespaces" do
      run("spec/tmp/work/pt.yml")
      expect(File.read("spec/tmp/work/named.pt.yml")).to eql("\npt:\n  something: Algo\n")
    end

    it "should work with namespaces" do
      run("spec/tmp/work/named.en.yml")
      files_should_match("named.pt")
      expect(File.read("spec/tmp/work/pt.yml")).to
         eql("\npt:\n  sync: To Sync It!\n  test: Teste\n  new: \"Uau, isso é novo\"\n")
    end

    it "should order alphabeticaly namespaces" do
      run("spec/tmp/work/order.pt.yml")
      files_should_match("order.en")
      File.read("spec/tmp/work/named.pt.yml").to eql("\npt:\n  something: Algo\n")
    end

    it "should work with extra chars" do
      run("spec/tmp/work/extra.en.yml")
      files_should_match("extra.pt")
    end

    it "should work with deep nestings" do
      run("spec/tmp/work/children.en.yml")
      files_should_match("children.pt")
    end

  end

  describe "Creating files" do

    it "should create a new one" do
      newfile = "spec/tmp/work/fo.yml"; `rm #{newfile}` if File.exists?(newfile)
      run("#{EN} fo")
      expect(File.read(newfile)).to eql("# Comment cool\n--- \nfo: \n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should create a new with the right name" do
      newfile = "spec/tmp/work/named.fo.yml"; `rm #{newfile}` if File.exists?(newfile)
      run("spec/tmp/work/named.en.yml fo")
      expect(File.read(newfile)).to eql("\n--- \nfo: \n  another: Another\n  something: Something\n")
    end

  end

  describe "Multi Files" do

    before do
      `rm -rf spec/tmp/workmulti`
      `cp -rf spec/fixtures spec/tmp/workmulti`
    end

    it "should sync a show directory" do
      run("spec/tmp/workmulti")
      files_should_match("extra.pt", :multi)
    end

  end

  describe "Add keys to i18n!" do

    it "should have a nice command to add stuff" do
      run("add dynamic Dynamic spec/tmp/work/en.yml")
      expect(File.read("spec/tmp/work/en.yml")).to eql("# Comment cool\n--- \nen: \n  dynamic: Dynamic\n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should work on a complex scenario" do
      run("add dynamic.nested.very.nasty Nasty spec/tmp/work/extra.en.yml")
      expect(File.read("spec/tmp/work/extra.en.yml")).to eql("\n--- \nen: \n  dynamic: \n    nested: \n      very: \n        nasty: Nasty\n  normal: Normal\n  with_colon: \"Value: Rock\"\n  yup: true\n")

    end
  end

end
