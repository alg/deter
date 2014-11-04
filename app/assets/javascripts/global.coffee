$ ->
  $("[data-toggle=tooltip]").tooltip(html: true)
  $(".noclick").on("click", (e) -> e.preventDefault())
