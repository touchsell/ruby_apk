module Android
  class UsesSdkTag < GenericTag
    use_tag '/manifest/uses-sdk'

    define_attribute :min_sdk_version, :alias => :minSdkVersion,
                     :default => 1, :type => :integer

    define_attribute :target_sdk_version, :alias => :targetSdkVersion,
                     :default => :min_sdk_version.to_proc, :type => :integer

    define_attribute :max_sdk_version, :alias => :maxSdkVersion,
                     :default => 0, :type => :integer
  end
end
