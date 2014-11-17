require 'test_helper'

class CfdiParserTest < MiniTest::Test

  def setup
    file = File.read(File.expand_path('../fixtures/cfdi_3_2.xml', __FILE__))
    @cfdi_parser = CfdiParser::CfdiParser.new(file)
  end

  def test_object_not_nil
    assert_equal @cfdi_parser.nil?, false
  end

  def test_get_version
    assert_equal @cfdi_parser.version, "3.2"
  end

  def test_get_total
    assert_equal @cfdi_parser.total, "116.00"
  end

  def test_get_subtotal
    assert_equal @cfdi_parser.subtotal, "100.00"
  end
end
