class ExperimentAspect < Struct.new(:name, :type, :sub_type, :raw_data, :data_reference)

  include Concerns::WithExtendedAttributes

  # extended attributes key
  alias_method :xa_key, :name

  def data
    unless defined? @data
      unless self.raw_data
        @data = nil
      else
        decoded = Base64.decode64(self.raw_data)

        require "nokogiri"
        doc = Nokogiri::XML(decoded)
        doc.to_xml.gsub(' ', '&nbsp;')

        require 'rexml/document'
        doc = REXML::Document.new(decoded)
        formatter = REXML::Formatters::Pretty.new
        formatter.compact = true
        formatter.write(doc, targetstr = "")

        @data = targetstr
      end
    end

    @data
  end

  def data=(v)
    @data = v
    self.raw_data = v.nil? ? nil : Base64.encode64(v)
  end

  def full_type
    [ self.type, self.sub_type ].reject(&:blank?).join(" / ")
  end

end
