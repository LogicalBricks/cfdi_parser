module CfdiParser
  class Cfdi_3_3 < Parser

    def version
      super('Version')
    end

    def tipo_de_comprobante
      attribute("//cfdi:Comprobante", 'TipoDeComprobante').value rescue nil
    end

    def total
      attribute("//cfdi:Comprobante", 'Total').value.to_f rescue nil
    end

    def serie
      attribute("//cfdi:Comprobante", 'Serie').value rescue nil
    end

    def folio
      attribute("//cfdi:Comprobante", 'Folio').value rescue nil
    end

    def subtotal
      attribute("//cfdi:Comprobante", 'SubTotal').value.to_f rescue nil
    end

    def nombre_emisor
      attribute("//cfdi:Emisor", 'Nombre').value rescue nil
    end

    def rfc_emisor
      attribute("//cfdi:Emisor", 'Rfc').value rescue nil
    end

    def nombre_receptor
      attribute("//cfdi:Receptor", 'Nombre').value rescue nil
    end

    def rfc_receptor
      attribute("//cfdi:Receptor", 'Rfc').value rescue nil
    end

    def total_impuestos_retenidos
      attribute("//cfdi:Impuestos", 'TotalImpuestosRetenidos').value.to_f rescue nil
    end

    def total_impuestos_trasladados
      attribute("//cfdi:Impuestos", 'TotalImpuestosTrasladados').value.to_f rescue nil
    end

    def impuestos_retenidos
      @impuestos_retenidos ||= xpath_without_node_conceptos('//cfdi:Retencion').map do |node|
        {
          impuesto: node.attributes.first.last.value,
          importe: node.attributes['Importe'].value.to_f
        }
      end rescue []
    end

    def impuestos_trasladados
      @impuestos_trasladados ||= xpath_without_node_conceptos('//cfdi:Traslado').map do |node|
        {
          impuesto: node.attributes['Impuesto'].value,
          tipo_factor: node.attributes['TipoFactor'].value,
          tasa_o_cuota: node.attributes['TasaOCuota'].value,
          importe: node.attributes['Importe'].value.to_f
        }
      end rescue []
    end

    def impuesto_trasladado_iva
      impuesto = impuestos_trasladados.find{ |h| h[:impuesto] == '002' }
      impuesto[:importe] if impuesto
    end

    def impuesto_trasladado_ieps
      impuesto = impuestos_trasladados.find{ |h| h[:impuesto] == '003' }
      impuesto[:importe] if impuesto
    end

    def impuesto_trasladado_local_ish
      impuesto = impuestos_locales_trasladados.find{ |h| h[:impuesto] == 'ISH' }
      impuesto[:importe] if impuesto
    end

    def impuesto_retenido_isr
      impuesto = impuestos_retenidos.find{ |h| h[:impuesto] == '001' }
      impuesto[:importe] if impuesto
    end

    def impuesto_retenido_iva
      impuesto = impuestos_retenidos.find{ |h| h[:impuesto] == '002' }
      impuesto[:importe] if impuesto
    end

    def impuesto_retenido_ieps
      impuesto = impuestos_retenidos.find{ |h| h[:impuesto] == '003' }
      impuesto[:importe] if impuesto
    end

    def impuesto_retenido_local_ins_y_vig
      impuesto = impuestos_locales_retenidos.find{ |h| h[:impuesto] == 'INS Y VIG' }
      impuesto[:importe] if impuesto
    end

    def descripcion
      xpath('//cfdi:Concepto').map { |node| node[:Descripcion] }.join(' ')
    end

    def metodo_pago
      attribute("//cfdi:Comprobante", 'MetodoPago').value rescue nil
    end

    def uso_cfdi
      attribute("//cfdi:Receptor", 'UsoCFDI').value rescue nil
    end

  end
end
