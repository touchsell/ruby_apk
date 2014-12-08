module Android
  class UsesSdkTag < GenericTag
    use_tag '/manifest/uses-sdk'

    define_attribute :min_sdk_version, :alias => :minSdkVersion, :default => 1,
                     :type => :integer

    define_attribute :target_sdk_version, :alias => :targetSdkVersion,
                     :default  => lambda { |instance| instance.target_sdk_version_default },
                     :type => :integer

    define_attribute :max_sdk_version, :alias => :maxSdkVersion, :default => 0,
                     :type => :integer

    def target_sdk_version_default
      min_sdk_version
    end

  end
end
