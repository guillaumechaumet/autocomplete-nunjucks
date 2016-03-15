fs = require 'fs'
path = require 'path'

nunjucksDocsURL = "http://mozilla.github.io/nunjucks/templating.html"

module.exports =
  selector: '.source.nunjucks, .text.html.nunjucks'

  # Tell autocomplete to fuzzy filter the results of getSuggestions(). W̥e are
  # still filtering by the first character of the prefix in this provider for
  # efficiency.
  filterSuggestions: true

  # Required: Return a promise, an array of suggestions, or null.
  getSuggestions: ({editor, bufferPosition, scopeDescriptor, prefix, activatedManually}) ->
    new Promise (resolve) ->
      suggestion =
        text: 'block' # OR
        snippet: 'block(${1:myArg})'
        displayText: 'someText' # (optional)
        replacementPrefix: 'so' # (optional)
        type: 'function' # (optional)
        leftLabel: '' # (optional)
        leftLabelHTML: '' # (optional)
        rightLabel: '' # (optional)
        rightLabelHTML: '' # (optional)
        className: '' # (optional)
        iconHTML: '' # (optional)
        description: '' # (optional)̥
        descriptionMoreURL: nunjucksDocsURL # (optional)
      resolve([text: 'something'])
  # getSuggestions: (request) ->
  #   completions = null
  #   scopes = request.scopeDescriptor.getScopesArray()
  #
  #   if @isCompletingValue(request)
  #     console.log 1
  #     completions = @getPropertyValueCompletions(request)
  #   else if @isCompletingPseudoSelector(request)
  #     console.log 2
  #     completions = @getPseudoSelectorCompletions(request)
  #   else
  #     if isnunjucks and @isCompletingNameOrTag(request)
  #       console.log 3
  #       completions = @getPropertyNameCompletions(request)
  #         .concat(@getTagCompletions(request))
  #     else if not isnunjucks and @isCompletingName(request)
  #       console.log 4
  #       completions = @getPropertyNameCompletions(request)
  #
  #   if not isnunjucks and @isCompletingTagSelector(request)
  #     tagCompletions = @getTagCompletions(request)
  #     if tagCompletions?.length
  #       console.log 5
  #       completions ?= []
  #       completions = completions.concat(tagCompletions)
  #
  #   completions
  #
  # onDidInsertSuggestion: ({editor, suggestion}) ->
  #   setTimeout(@triggerAutocomplete.bind(this, editor), 1) if suggestion.type is 'property'
  #
  # triggerAutocomplete: (editor) ->
  #   atom.commands.dispatch(atom.views.getView(editor), 'autocomplete-plus:activate', {activatedManually: false})
  #
  # loadProperties: ->
  #   @properties = {}
  #   fs.readFile path.resolve(__dirname, '..', 'completions.json'), (error, content) =>
  #     {@tags} = JSON.parse(content) unless error?
  #     return
  #
  # isCompletingValue: ({scopeDescriptor, bufferPosition, prefix, editor}) ->
  #   scopes = scopeDescriptor.getScopesArray()
  #
  #   previousBufferPosition = [bufferPosition.row, Math.max(0, bufferPosition.column - prefix.length - 1)]
  #   previousScopes = editor.scopeDescriptorForBufferPosition(previousBufferPosition)
  #   previousScopesArray = previousScopes.getScopesArray()
  #
  #   (hasScope(scopes, 'meta.property-value.css') and not hasScope(scopes, 'punctuation.separator.key-value.css')) or
  #   (hasScope(scopes, 'meta.property-value.scss') and not hasScope(scopes, 'punctuation.separator.key-value.scss')) or
  #   (hasScope(scopes, 'source.nunjucks') and (hasScope(scopes, 'meta.property-value.nunjucks') or
  #     (not hasScope(previousScopesArray, "entity.name.tag.css.nunjucks") and prefix.trim() is ":")
  #   ))
  #
  # isCompletingName: ({scopeDescriptor, bufferPosition, prefix, editor}) ->
  #   scopes = scopeDescriptor.getScopesArray()
  #   lineLength = editor.lineTextForBufferRow(bufferPosition.row).length
  #   isAtTerminator = prefix.endsWith(';')
  #   isAtParentSymbol = prefix.endsWith('&')
  #   isInPropertyList = not isAtTerminator and
  #     (hasScope(scopes, 'meta.property-list.css') or
  #     hasScope(scopes, 'meta.property-list.scss'))
  #
  #   return false unless isInPropertyList
  #   return false if isAtParentSymbol
  #
  #   previousBufferPosition = [bufferPosition.row, Math.max(0, bufferPosition.column - prefix.length - 1)]
  #   previousScopes = editor.scopeDescriptorForBufferPosition(previousBufferPosition)
  #   previousScopesArray = previousScopes.getScopesArray()
  #
  #   return false if hasScope(previousScopesArray, 'entity.other.attribute-name.class.css') or
  #     hasScope(previousScopesArray, 'entity.other.attribute-name.id.css') or
  #     hasScope(previousScopesArray, 'entity.other.attribute-name.id') or
  #     hasScope(previousScopesArray, 'entity.other.attribute-name.parent-selector.css') or
  #     hasScope(previousScopesArray, 'entity.name.tag.reference.scss') or
  #     hasScope(previousScopesArray, 'entity.name.tag.scss')
  #
  #   isAtBeginScopePunctuation = hasScope(scopes, 'punctuation.section.property-list.begin.css') or
  #     hasScope(scopes, 'punctuation.section.property-list.begin.scss')
  #   isAtEndScopePunctuation = hasScope(scopes, 'punctuation.section.property-list.end.css') or
  #     hasScope(scopes, 'punctuation.section.property-list.end.scss')
  #
  #   if isAtBeginScopePunctuation
  #     # * Disallow here: `canvas,|{}`
  #     # * Allow here: `canvas,{| }`
  #     prefix.endsWith('{')
  #   else if isAtEndScopePunctuation
  #     # * Disallow here: `canvas,{}|`
  #     # * Allow here: `canvas,{ |}`
  #     not prefix.endsWith('}')
  #   else
  #     true
  #
  # isCompletingNameOrTag: ({scopeDescriptor, bufferPosition, editor}) ->
  #   scopes = scopeDescriptor.getScopesArray()
  #   prefix = @getPropertyNamePrefix(bufferPosition, editor)
  #   return @isPropertyNamePrefix(prefix) and
  #     hasScope(scopes, 'meta.selector.css') and
  #     not hasScope(scopes, 'entity.other.attribute-name.id.css.nunjucks') and
  #     not hasScope(scopes, 'entity.other.attribute-name.class.nunjucks')
  #
  # isCompletingTagSelector: ({editor, scopeDescriptor, bufferPosition}) ->
  #   scopes = scopeDescriptor.getScopesArray()
  #   tagSelectorPrefix = @getTagSelectorPrefix(editor, bufferPosition)
  #   return false unless tagSelectorPrefix?.length
  #
  #   if hasScope(scopes, 'meta.selector.css')
  #     true
  #   else if hasScope(scopes, 'source.css.scss') or hasScope(scopes, 'source.css.less')
  #     not hasScope(scopes, 'meta.property-value.scss') and
  #       not hasScope(scopes, 'meta.property-value.css') and
  #       not hasScope(scopes, 'support.type.property-value.css')
  #   else
  #     false
  #
  # isCompletingPseudoSelector: ({editor, scopeDescriptor, bufferPosition}) ->
  #   scopes = scopeDescriptor.getScopesArray()
  #   if hasScope(scopes, 'meta.selector.css') and not hasScope(scopes, 'source.nunjucks')
  #     true
  #   else if hasScope(scopes, 'source.css.scss') or hasScope(scopes, 'source.css.less') or hasScope(scopes, 'source.nunjucks')
  #     prefix = @getPseudoSelectorPrefix(editor, bufferPosition)
  #     if prefix
  #       previousBufferPosition = [bufferPosition.row, Math.max(0, bufferPosition.column - prefix.length - 1)]
  #       previousScopes = editor.scopeDescriptorForBufferPosition(previousBufferPosition)
  #       previousScopesArray = previousScopes.getScopesArray()
  #       not hasScope(previousScopesArray, 'meta.property-name.scss') and
  #         not hasScope(previousScopesArray, 'meta.property-value.scss') and
  #         not hasScope(previousScopesArray, 'support.type.property-name.css') and
  #         not hasScope(previousScopesArray, 'support.type.property-value.css')
  #     else
  #       false
  #   else
  #     false
  #
  # isPropertyValuePrefix: (prefix) ->
  #   prefix = prefix.trim()
  #   prefix.length > 0 and prefix isnt ':'
  #
  # isPropertyNamePrefix: (prefix) ->
  #   return false unless prefix?
  #   prefix = prefix.trim()
  #   prefix.length > 0 and prefix.match(/^[a-zA-Z-]+$/)
  #
  # getImportantPrefix: (editor, bufferPosition) ->
  #   line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
  #   importantPrefixPattern.exec(line)?[1]
  #
  # getPreviousPropertyName: (bufferPosition, editor) ->
  #   {row} = bufferPosition
  #   while row >= 0
  #     line = editor.lineTextForBufferRow(row)
  #     propertyName = propertyNameWithColonPattern.exec(line)?[1]
  #     return propertyName if propertyName
  #     row--
  #   return
  #
  # getPropertyValueCompletions: ({bufferPosition, editor, prefix, scopeDescriptor}) ->
  #   property = @getPreviousPropertyName(bufferPosition, editor)
  #   values = @properties[property]?.values
  #   return null unless values?
  #
  #   scopes = scopeDescriptor.getScopesArray()
  #
  #   completions = []
  #   if @isPropertyValuePrefix(prefix)
  #     for value in values when firstCharsEqual(value, prefix)
  #       completions.push(@buildPropertyValueCompletion(value, property, scopes))
  #   else
  #     for value in values
  #       completions.push(@buildPropertyValueCompletion(value, property, scopes))
  #
  #   if importantPrefix = @getImportantPrefix(editor, bufferPosition)
  #     # attention: règle dangereux
  #     completions.push
  #       type: 'keyword'
  #       text: '!important'
  #       displayText: '!important'
  #       replacementPrefix: importantPrefix
  #       description: "Forces this property to override any other declaration of the same property. Use with caution."
  #       descriptionMoreURL: "#{nunjucksDocsURL}/Specificity#The_!important_exception"
  #
  #   completions
  #
  # buildPropertyValueCompletion: (value, propertyName, scopes) ->
  #   text = value
  #   text += ';' unless hasScope(scopes, 'source.nunjucks')
  #
  #   {
  #     type: 'value'
  #     text: text
  #     displayText: value
  #     description: "#{value} value for the #{propertyName} property"
  #     descriptionMoreURL: "#{nunjucksDocsURL}/#{propertyName}#Values"
  #   }
  #
  # getPropertyNamePrefix: (bufferPosition, editor) ->
  #   line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
  #   propertyNamePrefixPattern.exec(line)?[0]
  #
  # getPropertyNameCompletions: ({bufferPosition, editor, scopeDescriptor, activatedManually}) ->
  #   # Don't autocomplete property names in nunjucks on root level
  #   scopes = scopeDescriptor.getScopesArray()
  #   line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
  #   return [] if hasScope(scopes, 'source.nunjucks') and not line.match(/^(\s|\t)/)
  #
  #   prefix = @getPropertyNamePrefix(bufferPosition, editor)
  #   return [] unless activatedManually or prefix
  #
  #   completions = []
  #   for property, options of @properties when not prefix or firstCharsEqual(property, prefix)
  #     completions.push(@buildPropertyNameCompletion(property, prefix, options))
  #   completions
  #
  # buildPropertyNameCompletion: (propertyName, prefix, {description}) ->
  #   type: 'property'
  #   text: "#{propertyName}: "
  #   displayText: propertyName
  #   replacementPrefix: prefix
  #   description: description
  #   descriptionMoreURL: "#{nunjucksDocsURL}/#{propertyName}"
  #
  # getTagSelectorPrefix: (editor, bufferPosition) ->
  #   line = editor.getTextInRange([[bufferPosition.row, 0], bufferPosition])
  #   tagSelectorPrefixPattern.exec(line)?[2]
  #
  # getTagCompletions: ({bufferPosition, editor, prefix}) ->
  #   completions = []
  #   if prefix
  #     for tag in @tags when firstCharsEqual(tag, prefix)
  #       completions.push(@buildTagCompletion(tag))
  #   completions
  #
  # buildTagCompletion: (tag) ->
  #   type: 'tag'
  #   text: tag
  #   description: "Selector for {%#{tag}%} elements"
  #
  # hasScope = (scopesArray, scope) ->
  #   scopesArray.indexOf(scope) isnt -1
  #
  # firstCharsEqual = (str1, str2) ->
  #   str1[0].toLowerCase() is str2[0].toLowerCase()
