require 'test_helper'

class CfdiParserTest < MiniTest::Test

  def setup
    file = File.read(File.expand_path('../fixtures/cfdi_3_2.xml', __FILE__))
    @cfdi_parser = CfdiParser::CfdiParser.new(file)
  end

  def test_object_not_nil
    refute_nil @cfdi_parser
  end

  def test_get_version
    assert_equal "3.2", @cfdi_parser.version
  end

  def test_get_total
    assert_equal "116.00", @cfdi_parser.total
  end

  def test_get_subtotal
    assert_equal "100.00", @cfdi_parser.subtotal
  end
end
