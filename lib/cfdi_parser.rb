require "cfdi_parser/version"
require 'nokogiri'
require 'date'

module CfdiParser
  class CfdiParser
    attr_accessor :doc

    def initialize(cfdi)
      @doc = Nokogiri::XML(cfdi)
    end

    def is_version_3_2?
      version('version') == '3.2'
    end

    def is_version_3_3?
      version('Version') == '3.3'
    end

    def version(attr)
      attribute("//cfdi:Comprobante", attr).value rescue nil
    end

    def fecha_timbrado
      Date.strptime(attribute("//tfd:TimbreFiscalDigital", 'FechaTimbrado').value, '%Y-%m-%d') rescue nil
    end

    def impuesto_trasladado_iva
      impuesto = impuestos_trasladados.find{ |h| h[:impuesto] == 'IVA' }
      impuesto[:importe] if impuesto
    end

    def impuesto_trasladado_local_ish
      impuesto = impuestos_locales_trasladados.find{ |h| h[:impuesto] == 'I.S.H.' }
      impuesto[:importe] if impuesto
    end

    def impuestos_locales_trasladados
      begin
        impuestos = xpath('//implocal:TrasladosLocales')
      rescue
        impuestos = []
      end
      @impuestos_locales_trasladados ||= impuestos.map do |node|
        {
          impuesto: node.attributes['ImpLocTrasladado'].value,
          tasa: node.attributes['TasadeTraslado'].value,
          importe: node.attributes['Importe'].value.to_f
        }
      end rescue []
    end

    def impuesto_trasladado_ieps
      impuesto = impuestos_trasladados.find{ |h| h[:impuesto] == 'IEPS' }
      impuesto[:importe] if impuesto
    end

    def impuesto_retenido_iva
      impuesto = impuestos_retenidos.find{ |h| h[:impuesto] == 'IVA' }
      impuesto[:importe] if impuesto
    end

    def impuesto_retenido_isr
      impuesto = impuestos_retenidos.find{ |h| h[:impuesto] == 'ISR' }
      impuesto[:importe] if impuesto
    end

    def uuid
      attribute("//tfd:TimbreFiscalDigital", 'UUID').value rescue nil
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
