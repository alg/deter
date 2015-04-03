module ApplicationHelper

  def submenu_item(code, label, path)
    link = content_tag(:a, label, href: path)
    content_tag('li', link, class: @submenu == code ? 'active' : nil)
  end

  def dropdown_submenu_item(codes, label, &block)
    items = capture(&block)
    li_content = [
      content_tag(:a, label, href: '#', class: "dropdown-toggle", data: { toggle: 'dropdown' }, role: 'button', 'aria-expanded' => 'false'),
      content_tag(:ul, items, class: 'dropdown-menu', role: 'menu')
    ].join.html_safe

    content_tag(:li, li_content, class: codes.include?(@submenu) ? 'active' : nil)
  end

end
