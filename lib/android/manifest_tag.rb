module Android
  class ManifestTag < GenericTag
    MANIFEST_TAG = '/manifest'
    def initialize(manifest)
      super(manifest, MANIFEST_TAG)
      @attr['package'] = package
      @attr['versionCode'] = version_code
      @attr['versionName'] = version_name
      @attr['xmlns:android'] = xmlns_android
      @attr['sharedUserId'] = shared_user_id
      @attr['sharedUserLabel'] = shared_user_label
    end

    # manifest namespace
    # @return [string]
    # SHOULD ALWAYS BE "http://schemas.android.com/apk/res/android"
    def xmlns_android
      get_attribute_value(MANIFEST_TAG, 'android')
    end

    # package name
    # @return [string]
    def package
      get_attribute_value(MANIFEST_TAG, 'package')
    end

    # sharedUserId
    # @return [string]
    # set a particuliar userId to the application
    # can be used to share data between apps with same userID
    # certificates should be the same
    def shared_user_id
      get_attribute_value(MANIFEST_TAG, 'sharedUserId')
    end

    # sharedUserLabel
    # @return [string]
    def shared_user_label
      get_attribute_value(MANIFEST_TAG, 'sharedUserLabel')
    end

    # versionCode
    # @return [Integer]
    def version_code
      get_attribute_value(MANIFEST_TAG, 'versionCode').to_i
    end

    # versionName
    # @return [string]
    def version_name(lang = nil)
      unless lang
        get_attribute_value(MANIFEST_TAG, 'versionName')
      else
        get_attribute_value(MANIFEST_TAG, 'versionName', :find_option => {:lang => lang})
      end
    end

    # installLocation option
    # TODO
    def install_Location
      # TODO
      nil
    end
  end
end
