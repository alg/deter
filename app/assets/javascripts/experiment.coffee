$ ->
  return if $("body#experiments_show").length == 0
  new MoreLess null, (id, row) ->

$ ->
  return if $("body#experiments_realize").length == 0

  setTimeout (->
    st = I18n.t "experiments.realize.completed",
      time: moment(new Date()).format('MMMM D, YYYY h:mma')

    $("#status").html(st)
  ), 30000
