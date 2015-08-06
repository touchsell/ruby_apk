require 'rexml/document'
require 'stringio'


module Android
  # binary AXML parser
  # @see https://android.googlesource.com/platform/frameworks/base.git Android OS frameworks source
  # @note
  #   refer to Android OS framework code:
  #   
  #   /frameworks/base/include/androidfw/ResourceTypes.h,
  #   
  #   /frameworks/base/libs/androidfw/ResourceTypes.cpp
  class AXMLParser
    def self.axml?(data)
      (data[0..3] == "\x03\x00\x08\x00")
    end

    def initialize(axml)
      @io = StringIO.new(axml, "rb")
    end

    attr_reader :strings

    # parse binary xml
    # @return [REXML::Document]
    def parse
      parser = Android::Resource.new(@io.string[8..-1])
      @strings = parser.strings
      parser.xml_doc
    end
  end
end
