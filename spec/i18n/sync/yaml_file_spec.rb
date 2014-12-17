require 'spec_helper'

describe 'YAML File' do
  it 'should recognize some stuff' do
    file = YamlFile.new(fixture_path('en.yml'))
    expect(file.lang).to eq('en')
    expect(file.prefix).to be_nil
  end

  it 'should read data' do
    f = YamlFile.new(fixture_path('en.yml'))
    expect(f.data).to eql('sync' => 'To Sync It!', 'test' => 'Test')
  end

  it 'should read comments' do
    f = YamlFile.new(fixture_path('en.yml'))
    expect(f.instance_variable_get('@comm')).to eql("# Comment cool\n")
  end

  it 'should recognize path' do
    expect(YamlFile.new(fixture_path('en.yml')).path).to match('/spec/tmp')
  end

  describe 'Prefixes/namespaces' do
    let(:file) { YamlFile.new(fixture_path('named.en.yml')) }

    it 'should recognize prefixes stuff' do
      expect(file.prefix).to eq('named')
    end

    it 'should recognize lang' do
      expect(file.prefix).to eq('named')
      expect(file.lang).to eq('en')
    end

    it 'should recognize path' do
      expect(file.path).to match('/spec/tmp')
    end
  end
end

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
