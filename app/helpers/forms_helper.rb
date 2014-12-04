module FormsHelper

  def form_password_field(base, name, options = nil)
    form_textual_field(base, name, { field_type: 'password_field' }.merge(options || {}))
  end

  def form_text_field(base, name, options = nil)
    form_textual_field(base, name, { field_type: 'text_field' }.merge(options || {}))
  end

  def form_text_area(base, name, options = nil)
    form_textual_field(base, name, { field_type: 'text_area' }.merge(options || {}))
  end

  def form_textual_field(base, name, options = nil)
    options ||= {}

    id = idize(name)
    field_type = options[:field_type] || 'text_field'

    attrs = field_attrs(base, id)

    field_attrs = { class: "form-control", data: { bind: "valueWithInit: #{id}" } }
    field_attrs[:placeholder] = attrs[:placeholder] if attrs[:placeholder]
    field_attrs = field_attrs.merge(options[:field_options] || {})

    add_help(field_attrs, attrs)

    field = send("#{field_type}_tag", name, options[:value] || attrs[:default] || "", field_attrs)

    wrap_field(name, field, attrs, options)
  end

  def add_help(field_attrs, attrs)
    if attrs[:help]
      data = field_attrs[:data]
      data[:toggle] = "tooltip"
      data[:placement] = "top"
      field_attrs[:title] = attrs[:help]
    end
  end

  def wrap_field(name, field, attrs, options)
    label_cols = options[:label_cols] || 3
    field_cols = options[:field_cols] || (12 - label_cols)

    field_section = [ field ]
    # field_section << help_block(attrs[:help]) if attrs[:help]

    form_group(name, [
      label_tag(name, attrs[:label], class: "col-sm-#{label_cols} control-label"),
      content_tag(:div, field_section.join.html_safe, class: "col-sm-#{field_cols}")
    ].join.html_safe, options)
  end

  def form_select(base, name, options = nil)
    options ||= {}

    id = idize(name)

    attrs = field_attrs(base, id)
    opts = attrs[:options]
    opts = opts.invert if opts.kind_of? Hash

    field_attrs = { class: "form-control", data: { bind: "valueWithInit: #{id}" }, include_blank: true }.merge(options[:field_options] || {})
    add_help(field_attrs, attrs)

    field = select_tag(name, options_for_select(opts, options[:value] || attrs[:default]), field_attrs)

    wrap_field(name, field, attrs, options)
  end

  private

  def idize(name)
    name.to_s.gsub(/[\[\]]/, '_').gsub(/_+$/, '')
  end

  def form_group(name, content, options)
    attrs = { class: 'form-group' }

    if hl = options[:highlight]
      attrs[:data] = { bind: "css: { 'has-error': #{hl}() && #{idize(name)}_invalid() }" }
    end

    content_tag(:div, content, attrs)
  end

  def help_block(text)
    content_tag(:span, text.html_safe, class: "help-block")
  end

  def field_attrs(base, name)
    attrs = { label: nil, placeholder: nil, help: nil, default: nil }

    data = t("#{base}.#{name}")

    if data.kind_of? String
      attrs[:label]       = data
    else
      attrs[:label]       = data[:label]
      attrs[:placeholder] = data[:placeholder]
      attrs[:default]     = data[:default]
      attrs[:help]        = data[:help]
      attrs[:options]     = data[:options]
    end

    attrs
  end

end
