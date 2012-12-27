((context, definition) ->
  if 'function' is typeof require and
     typeof exports is typeof module
    return module.exports = definition
  return context.CoffeeStylesheets = definition
)(@, (->
  # abbreviation for typeof, because we use it a lot
  y=(v)->(typeof v)[0]

  # constructor
  C = (o) -> # options
    o = o or {}
    # only non-false need be declared
    #o.format = o.format or false # add whitespace to output
    o.space = if o.format then ' ' else ''
    o.indent = (o.format or '') and (o.indent or '  ')
    o.newline = (o.format or '') and (o.newline or "\n")
    o.selector = o.selector or 'a abbr address article aside audio b bdi bdo blockquote body button canvas caption cite code colgroup command data datagrid datalist dd del details dfn div dl dt em embed eventsource fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 head header hgroup html i iframe ins kbd keygen label legend li mark map menu meter nav noscript object ol optgroup option output p pre progress q ruby rp rt s samp script section select small source span strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul var video wbr'.split ' '
    o.property = o.property or 'align-content align-items align-self alignment-adjust alignment-baseline anchor-point animation animation-delay animation-direction animation-duration animation-iteration-count animation-name animation-play-state animation-timing-function appearance azimuth backface-visibility background background-attachment background-clip background-color background-image background-origin background-position background-repeat background-size baseline-shift binding bleed bookmark-label bookmark-level bookmark-state bookmark-target border border-bottom border-bottom-color border-bottom-left-radius border-bottom-right-radius border-bottom-style border-bottom-width border-collapse border-color border-image border-image-outset border-image-repeat border-image-slice border-image-source border-image-width border-left border-left-color border-left-style border-left-width border-radius border-right border-right-color border-right-style border-right-width border-spacing border-style border-top border-top-color border-top-left-radius border-top-right-radius border-top-style border-top-width border-width bottom box-decoration-break box-shadow box-sizing break-after break-before break-inside caption-side clear clip color color-profile column-count column-fill column-gap column-rule column-rule-color column-rule-style column-rule-width column-span column-width columns content counter-increment counter-reset crop cue cue-after cue-before cursor direction display dominant-baseline drop-initial-after-adjust drop-initial-after-align drop-initial-before-adjust drop-initial-before-align drop-initial-size drop-initial-value elevation empty-cells fit fit-position flex flex-basis flex-direction flex-flow flex-grow flex-shrink flex-wrap float float-offset font font-feature-settings font-family font-kerning font-language-override font-size font-size-adjust font-stretch font-style font-synthesis font-variant font-variant-alternates font-variant-caps font-variant-east-asian font-variant-ligatures font-variant-numeric font-variant-position font-weight grid-cell grid-column grid-column-align grid-column-sizing grid-column-span grid-columns grid-flow grid-row grid-row-align grid-row-sizing grid-row-span grid-rows grid-template hanging-punctuation height hyphens icon image-orientation image-rendering image-resolution inline-box-align justify-content left letter-spacing line-break line-height line-stacking line-stacking-ruby line-stacking-shift line-stacking-strategy list-style list-style-image list-style-position list-style-type margin margin-bottom margin-left margin-right margin-top marker-offset marks marquee-direction marquee-loop marquee-play-count marquee-speed marquee-style max-height max-width min-height min-width move-to nav-down nav-index nav-left nav-right nav-up opacity order orphans outline outline-color outline-offset outline-style outline-width overflow overflow-style overflow-wrap overflow-x overflow-y padding padding-bottom padding-left padding-right padding-top page page-break-after page-break-before page-break-inside page-policy pause pause-after pause-before perspective perspective-origin pitch pitch-range play-during position presentation-level punctuation-trim quotes rendering-intent resize rest rest-after rest-before richness right rotation rotation-point ruby-align ruby-overhang ruby-position ruby-span size speak speak-as speak-header speak-numeral speak-punctuation speech-rate stress string-set tab-size table-layout target target-name target-new target-position text-align text-align-last text-decoration text-decoration-color text-decoration-line text-decoration-skip text-decoration-style text-emphasis text-emphasis-color text-emphasis-position text-emphasis-style text-height text-indent text-justify text-outline text-shadow text-space-collapse text-transform text-underline-position text-wrap top transform transform-origin transform-style transition transition-delay transition-duration transition-property transition-timing-function unicode-bidi vertical-align visibility voice-balance voice-duration voice-family voice-pitch voice-range voice-rate voice-stress voice-volume volume white-space widows width word-break word-spacing word-wrap z-index'.split ' '
    #' # hack for vim syntax highlighting bug from long string above
    g = o.globals = o.globals or {} # global scope of coffee template function
    for x of o.selector
      ((x)->
        g[o.selector[x]] = g[o.selector[x]] or -> @selector(o.selector[x]).apply null, arguments
      )(x)
    for x of o.property
      clean = o.property[x].replace `/[^\w\d]+/ig`, '_'
      ((x)->
        g[clean] = g[clean] or -> @property(o.property[x]).apply null, arguments
      )(x)
    g.comment = (s,f) ->
      if f
        @literal '/*'+s
        f()
        @literal '*/'
      else
        @literal "/*#{s}*/"
    g.s = (s,f)->
      s=s.replace(/(^\s*|\s*$)/,'').split /,\s*/
      (@selector(s))(f)
    @o = o
    return

  C::render = (f, cb) ->
    # setup globals
    l=0 # hierarchical level
    dom=[] # selector matrices
    styles=[] # selector blocks
    o=@o # options (without requirement of `this.` context)
    g=o.globals # globals abbreviated
    g.selector=(n)->->
      a=arguments
      b = {} # attributes object
      # f # content function
      pl=l # previous level
      l=styles.length # hierarchical level
      # x # iteration integer
      s='' # interface signature
      for x of a # generate interface signature
        s+=y a[x] # e.g., (string, object, function) == 'sof'
      # we only accept: sof, sf, of, f
      if s is 'sof' or s is 'sf'
        n += a[0] # first arg is #id.class string
      if s is 'of'
        b = a[0] # first arg is attributes
      if s is 'sof'
        b = a[1] # second arg is attributes
      if o.length # attributes provided
        n += '#'+b.id if b.id
        n += '.'+b.class.split(' ').join('.') if b.class
      f = a[a.length-1]
      dom.push if y(n) isnt 'o' then [n] else n
      for c of dom
        if c is '0'
          b = dom[c]
          continue
        else
          x = []
          for w of b
            for v of dom[c]
              x.push b[w]+' '+dom[c][v]
          b = x
      styles[l] =
        selector: b
        properties: []
      f()
      dom.pop()
      l=pl
    g.property=(n)->(s)->
      styles[l].properties.push [n, s]
    g.literal=(s)->
      styles[l].properties.push s

    # begin render
    (Function 'g', 'with(g){('+f+')()}')(g)

    # compile result
    t = '' # resulting template string
    for k of styles when styles[k].properties.length
      t += "#{styles[k].selector.join(','+o.newline)}#{o.space}{#{o.newline}" # selector
      for kk of styles[k].properties
        if typeof styles[k].properties[kk] is 'object'
          t += "#{o.indent}#{styles[k].properties[kk][0]}:#{o.space}#{styles[k].properties[kk][1]};#{o.newline}" # property
        else
          t += o.indent + styles[k].properties[kk] + o.newline # literal
      if not o.format and t[t.length-1] is ';' then t = t.slice(0,-1) # chop last semi-colon
      t += "}#{o.newline}"
    @on.end t, (err, css) -> # execute any callback functions
      cb err, css
    return

  C::on = end: (t, cb) -> cb null, t # return template with no modifications; a placeholder until a plugin overrides it

  C::use = (cb) -> cb @

  return C
)())
