class window.MoreLess
  constructor: (scope = 'body', moreCallback = null) ->
    $("a.more", scope).on "click", (e) ->
      e.preventDefault()
      el = $(this)
      id = el.data('id')
      row = $("[data-more-id='#{id}']", scope)
      row.removeClass('hide')
      $("a.less[data-id='#{id}']", scope).removeClass('hide')
      el.addClass('hide')
      moreCallback(id, row) if moreCallback


    $("a.less").on "click", (e) ->
      e.preventDefault()
      el = $(this)
      id = el.data('id')
      $("[data-more-id='#{id}']", scope).addClass('hide')
      $("a.more[data-id='#{id}']", scope).removeClass('hide')
      el.addClass('hide')

    $("a.more-less").on "click", (e) ->
      e.preventDefault()
      el = $(this)
      id = el.data('id')
      row = $("[data-more-id='#{id}']", scope)
      row.toggleClass('hide')
      moreCallback(id, row) if !row.hasClass('hide') and moreCallback
