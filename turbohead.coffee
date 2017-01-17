head = document.head ? document.getElementsByTagName('head')[0]

unless head?
  throw new Error("[Turbohead] Can't work in document without head")

setattr = (el, attr, val) ->
  if attr of el
    el[attr] = val
  else
    el.setAttribute(attr, val)
  el

setattrs = (el, attrs) ->
  setattr(el, attr, val) for attr, val of attrs
  el

processMeta = ({charset, name, 'http-equiv': httpheader, content: newcontent}) ->
  if charset
    meta = head.querySelector('meta[name="charset"]') ? document.createElement('meta')
    setattr(meta, 'charset', charset)
    unless meta.parentNode?
      if head.firstChild?
        head.insertBefore(meta, head.firstChild)
      else
        head.appendChild(meta)
    return

  unless name or httpheader
    throw new TypeError('[Turbohead] Either meta[name] or meta[http-equiv] must be specified')

  idname  = if name then 'name' else 'http-equiv'
  idvalue = name or httpheader
  oldmeta = head.querySelector("""meta[#{idname}="#{idvalue}"]""")

  if newcontent
    meta = oldmeta ? document.createElement('meta')
    setattr(meta, idname, idvalue)
    setattr(meta, 'content', newcontent)
    head.appendChild(meta) unless meta.parentNode?

  else if oldmeta?
    oldmeta.parentNode.removeChild(oldmeta)

  return

processLink = (attributes) ->
  {rel}   = attributes
  newhref = attributes.href

  unless rel
    throw new TypeError('[Turbohead] Expected link[rel] to be specified')

  switch rel
    when 'canonical'
      oldlink = head.querySelector("""link[rel="#{rel}"]""")
      if newhref
        link = oldlink ? document.createElement('link')
        setattrs(link, attributes)
        head.appendChild(link) unless link.parentNode?

      else if oldlink?
        oldlink.parentNode.removeChild(oldlink)

    else
      throw new TypeError("[Turbohead] link[rel=#{rel}] isn't supported")

firstRun = true

@Turbohead =
  update: ({meta, link}) ->
    if firstRun
      firstRun = false
    else
      processMeta(item) for item in [].concat(meta) when item?
      processLink(item) for item in [].concat(link) when item?
    return

# Keep compatibility with old API.
@turbohead = (meta) -> Turbohead.update({meta})
