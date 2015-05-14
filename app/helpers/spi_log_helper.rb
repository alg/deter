require 'rexml/document'

module SpiLogHelper

  def format_log_xml(xml)
    doc = REXML::Document.new(xml)
    formatter = REXML::Formatters::Pretty.new
    formatter.compact = true
    formatter.write(doc, targetstr = "")
    targetstr
  end

end
