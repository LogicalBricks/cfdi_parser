require "cfdi_parser/version"
require 'nokogiri'
require 'date'

module CfdiParser
  class CfdiParser
    attr_accessor :doc

    def initialize(cfdi)
      @doc = Nokogiri::XML(cfdi)
    end

    def version
      attribute("//cfdi:Comprobante", 'version').value rescue nil
    end

    def tipo_de_comprobante
      attribute("//cfdi:Comprobante", 'tipoDeComprobante').value rescue nil
    end

    def total
      attribute("//cfdi:Comprobante", 'total').value.to_f rescue nil
    end

    def serie
      attribute("//cfdi:Comprobante", 'serie').value rescue nil
    end

    def folio
      attribute("//cfdi:Comprobante", 'folio').value rescue nil
    end

    def subtotal
      attribute("//cfdi:Comprobante", 'subTotal').value.to_f rescue nil
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
      attribute("//cfdi:Impuestos", 'totalImpuestosRetenidos').value.to_f rescue nil
    end

    def total_impuestos_trasladados
      attribute("//cfdi:Impuestos", 'totalImpuestosTrasladados').value.to_f rescue nil
    end

    def impuestos_retenidos
      @impuestos_retenidos ||= xpath('//cfdi:Retencion').map do |node|
        {
          impuesto: node.attributes.first.last.value,
          importe: node.attributes['importe'].value.to_f
        }
      end rescue []
    end

    def impuestos_trasladados
      @impuestos_trasladados ||= xpath('//cfdi:Traslado').map do |node|
        {
          impuesto: node.attributes['impuesto'].value,
          tasa: node.attributes['tasa'].value,
          importe: node.attributes['importe'].value.to_f
        }
      end rescue []
    end

    def fecha_timbrado
      Date.strptime(attribute("//tfd:TimbreFiscalDigital", 'FechaTimbrado').value, '%Y-%m-%d') rescue nil
    end

    def descripcion
      xpath('//cfdi:Concepto').map { |node| node[:descripcion] }.join(' ')
    end

    def metodo_pago
      attribute("//cfdi:Comprobante", 'metodoDePago').value rescue nil
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
