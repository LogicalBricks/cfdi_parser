require "cfdi_parser/version"
require 'nokogiri'

module CfdiParser
  class CfdiParser
    attr_accessor :doc

    def initialize(cfdi)
      @doc = Nokogiri::XML(cfdi)
      @namespaces = generate_namespaces
    end

    def version
      doc.xpath("//cfdi:Comprobante",namespaces).attribute('version').value rescue nil
    end

    def total
      doc.xpath("//cfdi:Comprobante",namespaces).attribute('total').value rescue nil
    end

    def subtotal
      doc.xpath("//cfdi:Comprobante",namespaces).attribute('subTotal').value rescue nil
    end

    private

    def namespaces
      @namespaces
    end

    def generate_namespaces
      namespaces = doc.collect_namespaces
      namespaces_names = {}
      namespaces.each_pair do |key, value|
        namespaces_names[key.sub(/^xmlns:/, '')] = value
      end
      namespaces_names
    end
  end
end
