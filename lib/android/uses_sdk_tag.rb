module Android
  class UsesSdkTag < GenericTag
    use_tag '/manifest/uses-sdk'

    define_attribute :min_sdk_version, :alias => :minSdkVersion, :default => 1, :type => :integer
    define_attribute :target_sdk_version, :alias => :targetSdkVersion, :default => :lambda, :lambda => lambda { |uses_sdk_tag| uses_sdk_tag.min_sdk_version}, :type => :integer
    define_attribute :max_sdk_version, :alias => :maxSdkVersion, :default => 0, :type => :integer
  end
end
