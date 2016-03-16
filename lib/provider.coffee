fs = require 'fs'
path = require 'path'

nunjucksDocsURL = "http://mozilla.github.io/nunjucks/templating.html"

module.exports =
  selector: '.source.nunjucks, .text.html.nunjucks'

  # Tell autocomplete to fuzzy filter the results of getSuggestions(). W̥e are
  # still filtering by the first character of the prefix in this provider for
  # efficiency.
  filterSuggestions: false

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    completions = null
    new Promise (resolve) ->
      suggestion =
        snippet: 'arrays'
        displayText: 'arrays'
        replacementPrefix: 'arrays'
        type: 'tag'
        description: 'arrays are great'
        descriptionMoreURL: '#{nunjucksDocsURL}'
      resolve([suggestion])
    completions

  loadProperties: ->
    @properties = {}
    fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
      {@tags} = JSON.parse(content) unless error?
      return
