$ ->
  return if $("body#experiments_show, body#experiments_manage").length == 0
  $("pre.view").each (i, e) ->
    w = $(e).parents("td").width()
    $(e).width(w - 20 - 2)

  new MoreLess null, (id, row) ->

$ ->
  return if $("body#experiments_realize").length == 0

  setTimeout (->
    st = I18n.t "experiments.realize.completed",
      time: moment(new Date()).format('MMMM D, YYYY h:mma')

    $("#status").html(st)
  ), 30000
