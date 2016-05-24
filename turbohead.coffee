firstRun = true

handleNamedMeta = ($head, attrs) ->
  $meta  = $head.find('meta[name="' + attrs.name + '"]')
  exists = !!$meta[0]
  if attrs.content
    $meta = $('<meta/>')  if not exists
    $meta.attr(attrs)
    $head.append($meta)   if not exists
  else if exists
    $meta.remove()
  return

handleCharsetMeta = ($head, attrs) ->
  $meta  = $head.find('meta[charset]')
  exists = !!$meta[0]
  $meta = $('<meta/>')  if not exists
  $meta.attr(attrs.charset)
  $head.append($meta)   if not exists
  return

@turbohead = (list) ->
  if firstRun
    firstRun = false
  else
    $head = $('head')
    return unless $head[0]?

    for attrs in list
      if attrs.name
        handleNamedMeta($head, attrs)
      else if attrs.charset
        handleCharsetMeta($head, attrs)
  return