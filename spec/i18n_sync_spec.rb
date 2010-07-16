# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

EN = "spec/work/en.yml"

def run(comm)
  `bin/i18s #{comm}`
end

describe "I18nSync" do
  before do
    `rm -rf spec/work`
    `cp -rf spec/fixtures spec/work`
  end

  it "should create a new one" do
    newfile = "spec/work/fo.yml"
    `rm #{newfile}` if File.exists?(newfile)
    run("#{EN} fo")
    File.read(newfile).should eql("\nfo: \n  sync: To Sync It!\n  test: Test\n")
  end

  it "should sync files nicely" do
    run("spec/work/pt.yml")
    File.read(EN).should eql("\nen: \n  new: \"Uau, isso é novo\"\n  sync: To Sync It!\n  test: Test\n")
  end

  it "should respect namespaces" do
    run("spec/work/pt.yml")
    File.read("spec/work/named.pt.yml").should eql("\npt:\n  something: Algo\n")
  end

  it "should respect namespaces" do
    run("spec/work/named.en.yml")
    File.read("spec/work/named.pt.yml").should eql("\npt: \n  another: Another\n  something: Algo\n")
  end

  it "should order alphabeticaly namespaces" do
    run("spec/work/order.pt.yml")
    File.read("spec/work/order.en.yml").should eql("\nen: \n  alpha: Alpha\n  blue: Blue\n  zebra: Zebra\n")
    File.read("spec/work/named.pt.yml").should eql("\npt:\n  something: Algo\n")
  end
end
