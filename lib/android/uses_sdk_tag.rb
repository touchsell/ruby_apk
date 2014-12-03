module Android
  class UsesSdkTag < GenericTag
    USES_SDK_TAG = '/manifest/uses-sdk'
    def initialize(manifest)
      super(manifest, USES_SDK_TAG)
      @attr['minSdkVersion'] = min_sdk_version
      @attr['targetSdkVersion'] = target_sdk_version
      @attr['maxSdkVersion'] = max_sdk_version
    end

    # @return [Integer] minSdkVersion in uses-sdk element
    # @return 1 when /manifest/uses-sdk is not found or attributes does not
    # exist cf http://developer.android.com/guide/topics/manifest/uses-sdk-element.html
    def min_sdk_version
      get_attribute_value(USES_SDK_TAG, 'minSdkVersion', :default => 1).to_i
    end

    # @return [Integer] targetSdkVersion in uses-sdk element
    # @return min_sdk_version when the attributes does not exist.
    def target_sdk_version
      get_attribute_value(USES_SDK_TAG, 'targetSdkVersion', :default => min_sdk_version).to_i
    end

    # @return [Integer] maxSdkVersion in uses-sdk element
    # should not be used according to official documentation at
    # http://developer.android.com/guide/topics/manifest/uses-sdk-element.html
    def max_sdk_version
      get_attribute_value(USES_SDK_TAG, 'maxSdkVersion', :default => 1).to_i
    end
  end
end
