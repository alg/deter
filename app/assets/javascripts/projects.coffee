$ ->
  return if $("body#projects_index").length == 0

  $("a.more").on "click", (e) ->
    e.preventDefault()
    el = $(this)
    pid = el.data('pid')
    $("tr[data-more-pid='#{pid}']").removeClass('hide')
    $("a.less[data-pid='#{pid}']").removeClass('hide')
    el.addClass('hide')

  $("a.less").on "click", (e) ->
    e.preventDefault()
    el = $(this)
    pid = el.data('pid')
    $("tr[data-more-pid='#{pid}']").addClass('hide')
    $("a.more[data-pid='#{pid}']").removeClass('hide')
    el.addClass('hide')
