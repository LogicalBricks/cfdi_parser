require "cfdi_parser/version"
require 'nokogiri'

module CfdiParser
  class CfdiParser
    attr_accessor :doc

    def initialize(cfdi)
      @doc = Nokogiri::XML(cfdi)
    end

    def version
      doc.xpath("//cfdi:Comprobante", namespaces).attribute('version').value rescue nil
    end

    def total
      doc.xpath("//cfdi:Comprobante", namespaces).attribute('total').value rescue nil
    end

    def subtotal
      doc.xpath("//cfdi:Comprobante", namespaces).attribute('subTotal').value rescue nil
    end

    private

    def namespaces
      @namespaces ||= generate_namespaces
    end

    def generate_namespaces
      doc.collect_namespaces.each_pair.with_object({}) do |(k, v), h|
        h[k.sub(/^xmlns:/, '')] = v
      end
    end
  end
end
