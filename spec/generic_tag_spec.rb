require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GenericTag" do
  context "with data/sample_AndroidManifest.xml data" do
    let(:bin_xml_path){ File.expand_path(File.dirname(__FILE__) + '/data/sample_AndroidManifest.xml') }
    let(:bin_xml){ File.open(bin_xml_path, 'rb') {|f| f.read } }
    let(:manifest){ Android::Manifest.new(bin_xml) }
    let(:generic_tag){Android::GenericTag.new(manifest)}

    it "should have the right manifest" do
      generic_tag.manifest.should be_instance_of Android::Manifest
      generic_tag.manifest.should == manifest
    end

    it "should be able to receive a class tag" do
      generic_tag.class.tag.should == nil
      generic_tag.class.use_tag("/manifest")
      generic_tag.class.tag.should == "/manifest"
    end

    it "should then be able to define attributes" do
      generic_tag.class.attr_definitions.should == {}

      generic_tag.class.define_attribute :package
      generic_tag.class.attr_definitions.should == { :package => {}  }
    end

    it "should be able to extract the values requested from the manifest" do
      generic_tag.attributes.should == { :package => "example.app.sample" }
    end
  end

  context "get_attribute_value" do
    let(:bin_xml_path){ File.expand_path(File.dirname(__FILE__) + '/data/sample_AndroidManifest.xml') }
    let(:bin_xml){ File.open(bin_xml_path, 'rb') {|f| f.read } }
    let(:manifest){ Android::Manifest.new(bin_xml) }
    let(:generic_tag){Android::GenericTag.new(manifest)}
    let(:res_path) { File.expand_path(File.dirname(__FILE__) + '/data/sample_resources.arsc') }
    let(:res_data) { File.read(res_path) }
    let(:resource) { Android::Resource.new(res_data) }

    it "should return nil if the element is not present and there is no default value" do
      generic_tag.get_attribute_value("fake_element", "fake_name").should == nil
    end

    it "should return the default value if the element is not present" do
      generic_tag.get_attribute_value("fake_element", "fake_name", :default => 1).should == 1
    end

    it "should return nil if the value does not exist and no default value" do
      generic_tag.get_attribute_value("/manifest", "fake_name").should == nil
    end

    it "should return the default value if the value does not exist" do
      generic_tag.get_attribute_value("/manifest", "fake_name", :default => 1).should == 1
    end

    it "should return a boolean if the return type is set to :boolean" do
      generic_tag.get_attribute_value("/manifest", "fake_name", :type => :boolean).should == false
      generic_tag.get_attribute_value("/manifest", "fake_name", :type => :boolean, :default => true).should == true
    end

    it "should return a FixNum if the return type is set to :integer" do
      generic_tag.get_attribute_value("fake_element", "fake_name", :type => :integer).should be_instance_of(Fixnum)
    end

    it "should return an address when there is no rsc element in the manifest" do
      generic_tag.get_attribute_value("/manifest/application", "icon").should =~ /^@(\w+\/\w+)|(0x[0-9a-fA-F]{8})$/
    end

    it "should find the resource in the rsc if present and matching the regex" do
      generic_tag.manifest  = Android::Manifest.new(bin_xml, resource)
      expected_result = ["res/drawable-ldpi/ic_launcher.png",
                         "res/drawable-mdpi/ic_launcher.png",
                         "res/drawable-hdpi/ic_launcher.png"]
      generic_tag.get_attribute_value("/manifest/application", "icon").should be_instance_of Array
      generic_tag.get_attribute_value("/manifest/application", "icon").should == expected_result
    end

    it "should execute the lambda function when present and :default != :lambda" do
      generic_tag.manifest.doc.elements["/manifest/application"].add_attribute("backupAgent",".mock")
      generic_tag.get_attribute_value("/manifest/application","backupAgent", :lambda => lambda {|application_tag, value| "#{application_tag.manifest.manifest_tag[:package]}#{value}"}).should == "example.app.sample.mock"
    end

    it "should execute the lambda function when present and :default == :lambda" do
      generic_tag.get_attribute_value("/manifest/uses-sdk", "targetSdkVersion", :default => :lambda, :lambda => lambda { |a|  42 }, :type => :integer ).should == 42
    end
  end
end
