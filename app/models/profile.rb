class Profile < Hash

  def [](name)
    case name
    when "address"
      address
    else
      fetch(name, nil)
    end
  end

  def address
    [ self['address1'], self['address2'] ].reject(&:blank?).join("<br/>").html_safe
  end

end
