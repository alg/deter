$ ->
  return if $("body#dashboard_show").length == 0

  # start loading team and experiments data
  $.ajax
    url: gon.resourcesUrl,
    success: (data) ->
      $(".resources").html(data)
