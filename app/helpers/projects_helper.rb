module ProjectsHelper

  # Returns the list of members with popovers
  def members_list(members)
    members.map do |m|
      member_list_item(m)
    end.join(", ").html_safe
  end

  private

  def member_list_item(m)
    permissions_list = m.permissions.map { |p| content_tag(:li, p) }
    member_tooltip = content_tag(:ul, permissions_list.join.html_safe).html_safe
    content_tag(:a, m.uid, href: "#", class: 'noclick', title: member_tooltip, data: { toggle: 'tooltip', placement: 'top' })
  end

end
