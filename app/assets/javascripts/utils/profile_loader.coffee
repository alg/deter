class window.ProfileLoader
  constructor: (@getProfileUrl) ->
    @profilesCache = {}
    @profilesLoading = {}

  insertSpinner: (cell) ->
    cell.addClass("loading")
    $("<div/>").addClass("spinner").appendTo(cell)

  removeSpinner: (cell) ->
    cell.removeClass("loading")
    $(".spinner", cell).remove()

  renderProperties: (cell, profile) ->
    table = $("<table/>").addClass('table')
    for p in profile.fields
      row = $("<tr/>")
      $("<th/>").text(p.description).appendTo(row)
      $("<td/>").text(p.value).appendTo(row)
      table.append(row)

    cell.append(table)

  loadData: (cell, id) ->
    @profilesLoading[id] = true
    @insertSpinner(cell)
    $.getJSON @getProfileUrl.replace(':id', id), (data) =>
      @profilesCache[id] = data
      @profilesLoading[id] = false
      @renderProperties(cell, data)
      @removeSpinner(cell)

  isLoaded: (id) ->
    @profilesCache[id] or @profilesLoading[id]

