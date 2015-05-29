$ ->
  return if $("body#projects_index").length == 0

  profileLoader = new ProfileLoader(gon.getProfileUrl)
  moreLess = new MoreLess null, (id, row) ->
    return if profileLoader.isLoaded(id)
    dataCell = $(".data-cell", row)
    profileLoader.loadData(dataCell, id)


$ ->
  return if $("body#projects_show, body#projects_manage").length == 0

  findButton = (section) ->
    $("button[data-target='#" + $(section)[0].id + "']")

  section = $(".section")
  section.on "shown.bs.collapse", ->
    section = $(this)
    button  = findButton(section)
    button.text("Hide")

  section.on "hidden.bs.collapse", ->
    section = $(this)
    button  = findButton(section)
    button.text("Show")

  # start loading team and experiments data
  $.getJSON gon.projectDetailsUrl, (data) ->
    $("#team-section .body").html(data.team_html)
    $("#experiments-section .body").html(data.experiments_html)
