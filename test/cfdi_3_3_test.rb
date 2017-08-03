require 'test_helper'

class Cfdi_3_3Test < MiniTest::Test

  def setup
    file = File.read(File.expand_path('../fixtures/cfdi_3_3.xml', __FILE__))
    @cfdi_parser = CfdiParser::Cfdi_3_3.new(file)
  end

  def test_get_version
    assert_equal "3.3", @cfdi_parser.version
  end

  def test_get_tipo_de_comprobante
    assert_equal "I", @cfdi_parser.tipo_de_comprobante
  end

  def test_get_serie
    assert_equal "SS", @cfdi_parser.serie
  end

  def test_get_folio
    assert_equal "1", @cfdi_parser.folio
  end

  def test_get_total
    assert_equal 1501.0, @cfdi_parser.total
  end

  def test_get_subtotal
    assert_equal 2000.0, @cfdi_parser.subtotal
  end

  def test_get_nombre_emisor
    assert_equal "MATERIALES MARROQUI SA DE CV", @cfdi_parser.nombre_emisor
  end

  def test_get_rfc_emisor
    assert_equal "ESI920427886", @cfdi_parser.rfc_emisor
  end

  def test_get_nombre_receptor
    assert_equal "GARCIA DE ALBA ZEPEDA JORGE ARTURO", @cfdi_parser.nombre_receptor
  end

  def test_get_rfc_receptor
    assert_equal "BAJS721028S88", @cfdi_parser.rfc_receptor
  end

  def test_get_total_impuestos_retenidos
    assert_equal 361.0, @cfdi_parser.total_impuestos_retenidos
  end

  def test_get_total_impuestos_trasladados
    assert_equal 0.0, @cfdi_parser.total_impuestos_trasladados
  end

  def test_get_impuestos_retenidos
    impuestos_retenidos = [
      { impuesto: '001', importe: 95.00 },
      { impuesto: '002', importe: 95.00 },
      { impuesto: '003', importe: 171.00 },
    ]
    assert_equal impuestos_retenidos, @cfdi_parser.impuestos_retenidos
  end

  def test_get_impuestos_trasladados
    impuestos_trasladados = [
      { impuesto: '002', tipo_factor: 'Tasa', tasa_o_cuota: '0.000000', importe: 0.00 },
    ]
    assert_equal impuestos_trasladados, @cfdi_parser.impuestos_trasladados
  end

  def test_get_fecha_trimbrado
    assert_equal Date.new(2017, 8, 3), @cfdi_parser.fecha_timbrado
  end

  def test_get_descripcion
    descripcion = 'PAgo Pago por servicios de desarrollo de software por cliente extanjero'
    assert_equal descripcion, @cfdi_parser.descripcion
  end

  def test_get_metodo_pago
    assert_equal 'PUE', @cfdi_parser.metodo_pago
  end

  def test_get_impuesto_trasladado_iva
    assert_equal 0.00, @cfdi_parser.impuesto_trasladado_iva
  end

  def test_get_impuesto_trasladado_ieps
    assert_nil @cfdi_parser.impuesto_trasladado_ieps
  end

  def test_get_impuesto_trasladado_local_ish
    assert_equal 57.0, @cfdi_parser.impuesto_trasladado_local_ish
  end

  def test_get_impuesto_retenido_isr
    assert_equal 95.00, @cfdi_parser.impuesto_retenido_isr
  end

  def test_get_impuesto_retenido_iva
    assert_equal 95.00, @cfdi_parser.impuesto_retenido_iva
  end

  def test_get_impuesto_retenido_ieps
    assert_equal 171.00, @cfdi_parser.impuesto_retenido_ieps
  end

  def test_get_impuesto_retenido_local_ins_y_vig
    assert_equal 95.0, @cfdi_parser.impuesto_retenido_local_ins_y_vig
  end

  def test_get_uuid
    assert_equal '7E1EB38E-786F-11E7-BA73-015CA153B379', @cfdi_parser.uuid
  end

  def test_get_uso_cfdi
    assert_equal 'P01', @cfdi_parser.uso_cfdi
  end
end
