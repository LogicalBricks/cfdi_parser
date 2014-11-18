require "cfdi_parser/version"
require 'nokogiri'

module CfdiParser
  class CfdiParser
    attr_accessor :doc

    def initialize(cfdi)
      @doc = Nokogiri::XML(cfdi)
    end

    def version
      attribute("//cfdi:Comprobante", 'version').value rescue nil
    end

    def total
      attribute("//cfdi:Comprobante", 'total').value rescue nil
    end

    def subtotal
      attribute("//cfdi:Comprobante", 'subTotal').value rescue nil
    end

    def nombre_emisor
      attribute("//cfdi:Emisor", 'nombre').value rescue nil
    end

    def rfc_emisor
      attribute("//cfdi:Emisor", 'rfc').value rescue nil
    end

    def nombre_receptor
      attribute("//cfdi:Receptor", 'nombre').value rescue nil
    end

    def rfc_receptor
      attribute("//cfdi:Receptor", 'rfc').value rescue nil
    end

    def total_impuestos_retenidos
      attribute("//cfdi:Impuestos", 'totalImpuestosRetenidos').value rescue nil
    end

    def total_impuestos_trasladados
      attribute("//cfdi:Impuestos", 'totalImpuestosTrasladados').value rescue nil
    end

    def impuestos_retenidos
      xpath('//cfdi:Retencion').map do |node|
        {
          impuesto: node.attributes.first.last.value,
          importe: node.attributes['importe'].value
        }
      end
    end

    def impuestos_trasladados
      xpath('//cfdi:Traslado').map do |node|
        {
          impuesto: node.attributes['impuesto'].value,
          tasa: node.attributes['tasa'].value,
          importe: node.attributes['importe'].value
        }
      end
    end

    private # ======================== PRIVATE ========================== #

    def attribute(path, attr)
      xpath(path).attribute(attr)
    end

    def xpath(path)
      doc.xpath(path, namespaces)
    end

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
