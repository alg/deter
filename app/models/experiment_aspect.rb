class ExperimentAspect < Struct.new(:name, :type, :sub_type, :data, :data_reference)

  include Concerns::WithExtendedAttributes

  # extended attributes key
  alias_method :xa_key, :name

  def formatted_data
    return nil unless self.data

    decoded = Base64.decode64(self.data)

    require "nokogiri"
    doc = Nokogiri::XML(decoded)
    doc.to_xml.gsub(' ', '&nbsp;')

    require 'rexml/document'
    doc = REXML::Document.new( decoded)
    formatter = REXML::Formatters::Pretty.new
    formatter.compact = true
    formatter.write(doc, targetstr = "")

    targetstr
  end

end
