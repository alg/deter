profilesCache = {}
profilesLoading = {}

insertSpinner = (cell) ->
  $("<div/>").addClass("spinner").appendTo(cell)

removeSpinner = (cell) ->
  cell.removeClass("loading")
  $(".spinner", cell).remove()

renderProperties = (cell, profile) ->
  console.log(profile)
  table = $("<table/>").addClass('table')
  for p in profile.fields
    row = $("<tr/>")
    $("<th/>").text(p.description).appendTo(row)
    $("<td/>").text(p.value).appendTo(row)
    table.append(row)

  cell.append(table)

loadData = (cell, pid) ->
  cell.addClass("loading")
  profilesLoading[pid] = true
  $.getJSON gon.getProfileUrl.replace(':id', pid), (data) ->
    profilesCache[pid] = data
    profilesLoading[pid] = false
    renderProperties(cell, data)
    removeSpinner(cell)


$ ->
  return if $("body#projects_index").length == 0

  $("a.more").on "click", (e) ->
    e.preventDefault()
    el = $(this)
    pid = el.data('pid')
    profileRow = $("tr[data-more-pid='#{pid}']")
    profileRow.removeClass('hide')
    $("a.less[data-pid='#{pid}']").removeClass('hide')
    el.addClass('hide')

    if !profilesCache[pid] and !profilesLoading[pid]
      # show spinner, start loading if not loading yet
      dataCell = $(".data-cell", profileRow)
      insertSpinner(dataCell)
      loadData(dataCell, pid)

  $("a.less").on "click", (e) ->
    e.preventDefault()
    el = $(this)
    pid = el.data('pid')
    $("tr[data-more-pid='#{pid}']").addClass('hide')
    $("a.more[data-pid='#{pid}']").removeClass('hide')
    el.addClass('hide')
