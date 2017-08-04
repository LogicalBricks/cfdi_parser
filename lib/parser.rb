require 'nokogiri'
require 'date'

module CfdiParser
  class Parser
    attr_accessor :doc, :doc_without_node_conceptos

    def initialize(cfdi)
      @doc = Nokogiri::XML(cfdi)
      @doc_without_node_conceptos = Nokogiri::XML(cfdi)
      @doc_without_node_conceptos.search('//cfdi:Conceptos').remove
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

    def impuestos_locales_retenidos
      begin
        impuestos = xpath('//implocal:RetencionesLocales')
      rescue
        impuestos = []
      end
      @impuestos_locales_retenidos ||= impuestos.map do |node|
        {
          impuesto: node.attributes['ImpLocRetenido'].value,
          tasa: node.attributes['TasadeRetencion'].value,
          importe: node.attributes['Importe'].value.to_f
        }
      end rescue []
    end

    def uuid
      attribute("//tfd:TimbreFiscalDigital", 'UUID').value rescue nil
    end

    private # ======================== PRIVATE ========================== #

    def attribute(path, attr)
      select_element(xpath(path), attr).attribute(attr)
    end

    def select_element(nodeSet, attr)
      nodeSet.select {|element| element.attribute(attr)}.first
    end

    def xpath(path)
      doc.xpath(path, namespaces)
    end

    def xpath_without_node_conceptos(path)
      doc_without_node_conceptos.xpath(path, namespaces)
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

