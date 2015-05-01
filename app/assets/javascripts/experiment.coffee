$ ->
  return if $("body#experiments_show").length == 0
  new MoreLess null, (id, row) ->
