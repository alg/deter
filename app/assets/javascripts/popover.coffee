class window.Popover
  constructor: (id, errors, highlightTrigger = null) ->
    @errors = errors
    @el = $(id).popover(content: @popoverContent, title: 'Please review', html: true, trigger: 'hover')
    @po = @el.data()['bs.popover']

    if highlightTrigger
      $(id).on 'click', (e) ->
        e.preventDefault()
        highlightTrigger(true)

    errors.subscribe(@update) if errors.subscribe
    @update()

  update: =>
    @po.enabled = @errors().length > 0

  popoverContent: =>
    items = @errors()
    if items.length > 0
      "<ul>#{('<li>' + i + '</li>' for i in items).join('')}</ul>"
    else
      null

