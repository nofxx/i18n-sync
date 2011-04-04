# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

EN = "spec/work/en.yml"

def run(comm)
  `bin/i18s #{comm}`
end

describe "I18nSync" do
  before(:each) do
    `rm -rf spec/work`
    `cp -rf spec/fixtures spec/work`
  end

  describe "Unit" do

    let(:i) { I18S.new("spec/work/en.yml") }

    it "should parse master file" do
      i.instance_variable_get("@path").should eql("spec/work")
      i.instance_variable_get("@lang").should eql("en")
      i.instance_variable_get("@file").should eql("en.yml")
    end

    it "should read comments" do
      i.instance_variable_get("@comments").should eql("# Comment cool\n")
    end

    it "should read the hash" do
      i.instance_variable_get("@words").should eql({"sync"=>"To Sync It!", "test"=>"Test"})
    end

    it "should work fine with other files" do
      i2 = I18S.new("spec/work/pt.yml")
      i2.instance_variable_get("@lang").should eql("pt")
      i2.instance_variable_get("@comments").should be_empty
    end

  end

  describe "Namespaced" do
    let(:i) { I18S.new("spec/work/named.en.yml") }

    it "should parse master file" do
      i.instance_variable_get("@path").should eql("spec/work")
      i.instance_variable_get("@lang").should eql("en")
      i.instance_variable_get("@namespace").should eql("named")
      i.instance_variable_get("@file").should eql("named.en.yml")
    end

    it "should read the hash" do
      i.instance_variable_get("@words").should eql({"something"=>"Something", "another"=>"Another"})
    end

  end

  describe "Acceptance" do

    it "should create a new one" do
      newfile = "spec/work/fo.yml"
      `rm #{newfile}` if File.exists?(newfile)
      run("#{EN} fo")
      File.read(newfile).should eql("# Comment cool\n--- \nfo: \n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should sync files nicely" do
      run("spec/work/pt.yml")
      File.read(EN).should eql("\n--- \nen: \n  new: \"Uau, isso é novo\"\n  sync: \"To Sync It!\"\n  test: Test\n")
    end

    it "should respect namespaces" do
      run("spec/work/pt.yml")
      File.read("spec/work/named.pt.yml").should eql("\npt:\n  something: Algo\n")
    end

    it "should work with namespaces" do
      run("spec/work/named.en.yml")
      File.read("spec/work/named.pt.yml").should eql("\n--- \npt: \n  another: Another\n  something: Algo\n")
      File.read("spec/work/pt.yml").should eql("\npt:\n  sync: To Sync It!\n  test: Teste\n  new: \"Uau, isso é novo\"\n")
    end

    it "should order alphabeticaly namespaces" do
      run("spec/work/order.pt.yml")
      File.read("spec/work/order.en.yml").should eql("\n--- \nen: \n  alpha: Alpha\n  blue: Blue\n  zebra: Zebra\n")
      File.read("spec/work/named.pt.yml").should eql("\npt:\n  something: Algo\n")
    end

    it "should work with extra chars" do
      run("spec/work/extra.en.yml")
      File.read("spec/work/extra.pt.yml").should eql("\n--- \npt: \n  normal: Normal\n  with_colon: \"Value: Rock\"\n  yup: Sim\n")
    end

  end

end
