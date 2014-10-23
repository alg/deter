window.filled  = (v) -> !!v && !v.match(/^\s*$/)

# Value handler that respects the existing value
ko.bindingHandlers.valueWithInit = {
  init: (element, valueAccessor, allBindingsAccessor, context) ->
    property = valueAccessor()
    value = $(element).val()

    ko.bindingHandlers.value.init(element, valueAccessor, allBindingsAccessor, context)
    property(value)

  update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    ko.bindingHandlers.value.update(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext)
}

ko.bindingHandlers.checkedWithInit = {
  init: (element, valueAccessor, allBindingsAccessor, context) ->
    property = valueAccessor()
    el = $(element)
    checked = el.is(':checked')
    value   = el.val()

    ko.bindingHandlers.checked.init(element, valueAccessor, allBindingsAccessor, context)
    if checked
      if el.is(":checkbox")
        property(checked)
      else
        property(value)

  update: (element, valueAccessor, allBindingsAccessor, viewModel, bindingContext) ->
    ko.bindingHandlers.checked.update(element, valueAccessor, allBindingsAccessor, viewModel, bindingContext)
}
#
# Localized errors
class window.I18nErrors
  constructor: (base) -> @base = base
  t: (key) -> I18n.t("#{@base}.#{key}")

