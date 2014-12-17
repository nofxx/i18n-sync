require 'spec_helper'

describe "YAML File" do

  it 'should recognize some stuff' do
    f = YamlFile.new("spec/tmp/work/en.yml")
    expect(f.lang).to eq('en')
  end

end
  #   let(:i) { I18S.new("spec/tmp/work/en.yml") }

  #   it "should parse master file" do
  #     expect(i.instance_variable_get("@path")).to eql("spec/tmp/work")
  #     expect(i.instance_variable_get("@lang")).to eql("en")
  #     expect(i.instance_variable_get("@file")).to eql("en.yml")
  #   end

  #   it "should read comments" do
  #     expect(i.instance_variable_get("@comments")).to eql("# Comment cool\n")
  #   end

  #   it "should read the hash" do
  #     expect(i.instance_variable_get("@words")).to eql({"sync"=>"To Sync It!", "test"=>"Test"})
  #   end

  #   it "should work fine with other files" do
  #     i2 = I18S.new("spec/tmp/work/pt.yml")
  #     expect(i2.instance_variable_get("@lang")).to eql("pt")
  #     expect(i2.instance_variable_get("@comments")).to be_empty
  #   end

  # end

  # describe "Namespaced" do

  #   let(:i) { I18S.new("spec/tmp/work/named.en.yml") }

  #   it "should parse master file" do
  #     expect(i.instance_variable_get("@path")).to eql("spec/tmp/work")
  #     expect(i.instance_variable_get("@lang")).to eql("en")
  #     expect(i.instance_variable_get("@namespace")).to eql("named")
  #     expect(i.instance_variable_get("@file")).to eql("named.en.yml")
  #   end

  #   it "should read the hash" do
  #     expect(i.instance_variable_get("@words")).
  #        to eql({"something"=>"Something", "another"=>"Another"})
  #   end

  # end
