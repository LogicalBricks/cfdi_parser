require 'test_helper'

class CfdiParserTest < MiniTest::Test

  def setup
    file = File.read(File.expand_path('../fixtures/cfdi_3_2.xml', __FILE__))
    @cfdi_parser = CfdiParser::CfdiParser.new(file)
  end

  def test_valid_object
    assert_equal @cfdi_parser.nil?, false
  end
end
