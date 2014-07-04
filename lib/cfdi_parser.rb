require "cfdi_parser/version"
require 'nokogiri'

module CfdiParser
  class CfdiParser
    def initialize(cfdi)
      doc = Nokogiri::XML(cfdi)
    end
  end
end
