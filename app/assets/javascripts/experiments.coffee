$ ->
  return if $("body#experiments_index").length == 0

  profileLoader = new ProfileLoader(gon.getProfileUrl)
  moreLess = new MoreLess null, (id, row) ->
    return if profileLoader.isLoaded(id)
    dataCell = $(".data-cell", row)
    profileLoader.loadData(dataCell, id)

