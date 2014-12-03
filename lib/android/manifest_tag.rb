module Android
  class ManifestTag < GenericTag
    use_tag '/manifest'

    define_attribute :xmlns_android, :alias => :android
    define_attribute :package
    define_attribute :shared_user_id, :alias => :sharedUserId
    define_attribute :shared_user_label, :alias => :sharedUserLabel
    define_attribute :version_code, :alias => :versionCode, :type => :integer
    define_attribute :version_name, :alias => :versionName
    define_attribute :install_Location, :alias => :installLocation #TODO
  end
end
