require 'test_helper'

class CfdiParserTest < MiniTest::Test

  def test_is_version_3_2?
    file = File.read(File.expand_path('../fixtures/cfdi_3_2.xml', __FILE__))
    @cfdi_parser = CfdiParser::CfdiParser.new(file)
    assert(@cfdi_parser.is_version_3_2?, 'must be true')
  end

  def test_is_version_3_3?
    file = File.read(File.expand_path('../fixtures/cfdi_3_3.xml', __FILE__))
    @cfdi_parser = CfdiParser::CfdiParser.new(file)
    assert(@cfdi_parser.is_version_3_3?, 'must be true')
  end
end
