# CoffeeStylesheets

## What if you could write CoffeeScript like:

```coffeescript
body ->
  background 'black'
  color 'red'
  p ->
    font_size '12px'
    border_radius px 5

comment 'and now something more complex'
serve_pie = ->
  # adds ie7 support for css3 border-radius, box-shadow, and linear-gradient
  position 'relative'
  prop 'behavior', 'url(/assets/css3pie/PIE.htc)'
pie_gradient = (a, b) ->
  background a
  prop '-pie-background', linear_gradient a, b # prop stands for property
s 'html.ie7', -> # s stands for selector
  s '.section#content', ->
    table '#anyId.anyClass1.anyClass2', ->
      serve_pie()
      th id: 'anotherId', class: 'anotherClass1 anotherClass2', ->
        serve_pie()
        # literal means literally what you provide will be output without modification
        literal '-webkit-filter: blur(2px) grayscale (.5) opacity(0.8) hue-rotate(120deg);'
```

and get back a CSS3 stylesheet, like:

```css
/* line 1418, precompile/assets/stylesheets/ie7.css.coffee */
body {
  background: black;
  color: red; }
/* line 1420, precompile/assets/stylesheets/ie7.css.coffee */
body p {
  font-size: 12px;
  -moz-border-radius: 5px;
  -webkit-border-radius: 5px;
  border-radius: 5px; }

/* and now something more complex */
/* line 1421, precompile/assets/stylesheets/ie7.css.coffee */
html.ie7 .section#content table#anyId.anyClass1.anyClass2 {
  position: relative;
  behavior: url(/assets/css3pie/PIE.htc); }
/* line 1423, precompile/assets/stylesheets/ie7.css.coffee */
html.ie7 .section#content table#anyId.anyClass1.anyClass2 th#anotherId.anotherClass1.anotherClass2 {
  position: relative;
  behavior: url(/assets/css3pie/PIE.htc); 
  -webkit-filter: blur(2px) grayscale (.5) opacity(0.8) hue-rotate(120deg); }
```

## Now, you can!

Just wrap it in this:

```coffeescript
engine = new CoffeeStylesheets
 format: true # optional
 globals: # optional
   px: (i) -> i + 'px' # a silly example of custom helpers
   # the cross-browser version of border_radius() is provided by the CoffeeStylesheetsCompassFramework plugin 
engine.render stylesheet, (err, css) ->
  console.log css
```

## Why this monstrosity?

* stand-alone; NO dependencies
* eliminates double-trees server/client-side in terms of both a) templating engines, and b) template files
* yet to be benchmarked, but likely 90% faster compilation than tokenizers (stylus, less, sass)
* only one language to write; one language to teach/master; one language to rule them all!
* common functions provided by js libs available and executed in same scope as stylesheet e.g., require()
* helps eliminate intermediary steps between the initial precompilation syntax sugar and the end result

## FAQ

 * **Do I have to use CoffeeScript?**
 While composing in CoffeeScript is obviously the point, you could store the compiled javascript version of the
template, and after that no coffee-script dependency is required. There is a pure javascript version of
the engine provided, as well.

 * **Does it only work in Node.js or client-side/in-browser as well?**
 It is designed to be used on either side. This is why it is lightweight, with no dependencies.

## See also

* Works well with [CoffeeTemplates](https://github.com/mikesmullin/coffee-templates) 
* Has a plugin called [CoffeeSprites](https://github.com/mikesmullin/coffee-sprites)
* Has a plugin called [CoffeeStylesheetsCompassFramework](https://github.com/mikesmullin/coffee-stylesheets-compass-framework)
* Thanks to Nino Paolo for beginning work on a [SASS to CoffeeStylesheets Converter](https://github.com/paolooo/coffee-espresso-two-shots)
