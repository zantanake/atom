fs = require 'fs'
_ = require 'underscore'

# This a weirdo file. We don't create a Window class, we just add stuff to
# the DOM window.
#
# Events:
#   window:load - Same as window.onLoad. Final event of app startup.
windowAdditions =
  url: $atomController.url?.toString()

  startup: ->
    if not @resource = atom.router.open @url
      throw "I DON'T KNOW ABOUT #{@url}"

    atom.trigger 'window:load', this

  shutdown: ->
    $atomController.close

  showConsole: ->
    $atomController.webView.inspector.showConsole true

  setTitle: (title) ->
    $atomController.window.title = title

  open: (url) ->
    url = atom.native.openPanel() unless url
    (@resource.open url) or atom.app.open url

  close: ->
    @resource.close() or @shutdown()

  save: ->
    @resource.save()

  onerror: ->
    @showConsole true

  handleKeyEvent: ->
    atom.keybinder.handleEvent arguments...

  triggerEvent: ->
    atom.trigger arguments...

for key, value of windowAdditions
  console.warn "DOMWindow already has a key named `#{key}`" if window[key]
  window[key] = value
