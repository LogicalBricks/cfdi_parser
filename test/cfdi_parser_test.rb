require 'test_helper'

class CfdiParserTest < MiniTest::Test

  def setup
    file = File.read(File.expand_path('../fixtures/cfdi_3_2.xml', __FILE__))
    @cfdi_parser = CfdiParser::CfdiParser.new(file)
  end

  def test_get_version
    assert_equal "3.2", @cfdi_parser.version
  end

  def test_get_serie
    assert_equal "A", @cfdi_parser.serie
  end

  def test_get_folio
    assert_equal "1", @cfdi_parser.folio
  end

  def test_get_total
    assert_equal "116.00", @cfdi_parser.total
  end

  def test_get_subtotal
    assert_equal "100.00", @cfdi_parser.subtotal
  end

  def test_get_nombre_emisor
    assert_equal "EMPRESA DE MUESTRA WEB SERVICES S.A de C.V.", @cfdi_parser.nombre_emisor
  end

  def test_get_rfc_emisor
    assert_equal "ESI920427886", @cfdi_parser.rfc_emisor
  end

  def test_get_nombre_receptor
    assert_equal "PUBLICO EN GENERAL", @cfdi_parser.nombre_receptor
  end

  def test_get_rfc_receptor
    assert_equal "XAXX010101000", @cfdi_parser.rfc_receptor
  end

  def test_get_total_impuestos_retenidos
    assert_equal "1234.56", @cfdi_parser.total_impuestos_retenidos
  end

  def test_get_total_impuestos_trasladados
    assert_equal "789.01", @cfdi_parser.total_impuestos_trasladados
  end

  def test_get_impuestos_retenidos
    impuestos_retenidos = [
      { impuesto: 'ISR', importe: '103.5' },
      { impuesto: 'IVA', importe: '164.04' },
    ]
    assert_equal impuestos_retenidos, @cfdi_parser.impuestos_retenidos
  end

  def test_get_impuestos_trasladados
    impuestos_trasladados = [
      { impuesto: 'IVA', tasa: '16.0', importe: '845.61' },
    ]
    assert_equal impuestos_trasladados, @cfdi_parser.impuestos_trasladados
  end
end
