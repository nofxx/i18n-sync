# -*- coding: utf-8 -*-
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

EN = "spec/work/en.yml"

describe "I18nSync" do
  before do
    `rm -rf spec/work`
    `cp -rf spec/fixtures spec/work`
  end

  it "should create a new one" do
    newfile = "spec/work/fo.yml"
    `rm #{newfile}` if File.exists?(newfile)
    `bin/i18s #{EN} fo`
    File.read(newfile).should eql("\nfo: \n  sync: To Sync It!\n  test: Test\n")
  end

  it "should sync files nicely" do
    `bin/i18s spec/work/pt.yml`
    File.read(EN).should eql("\nen: \n  new: \"Uau, isso é novo\"\n  sync: To Sync It!\n  test: Test\n")
  end
end
