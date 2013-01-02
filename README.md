# What if you could write CoffeeScript like:

```coffeescript
body ->
  background 'black'
  color 'red'
  p ->
    font_size '12px'
    border_radius px 5
```

and get back a CSS3 stylesheet, like:

```css
body {
  background: black;
  color: red;
}
body p {
  font-size: 12px;
  -moz-border-radius: 5px; /* Firefox */
  -webkit-border-radius: 5px; /* Safari, Chrome */
  border-radius: 5px; /* CSS3 */
}
```

Now, you can!

Just wrap it in this:

```coffeescript
engine = new CoffeeStylesheets
 format: true
 globals:
   px: (i) -> i + 'px'
   # this is like a nib/compass cross-browser helper
   border_radius: (s)-> @literal """
     -moz-border-radius: #{s}; /* Firefox */
       -webkit-border-radius: #{s}; /* Safari, Chrome */
       border-radius: #{s}; /* CSS3 */
   """
engine.render stylesheet, (err, css) ->
  console.log css
```

## Why this monstrosity?

```coffeescript
# * in the end it compiles to pure-js concatenation. no string parsing necessary
# * no engine (like sass or stylus) is required to render data through the templates
# * template compilation is like 90% faster than stylus
# * it eliminates potential complexities of double-trees between server-side and client-side templating engines and templates
# * stand-alone; no dependencies
# * only one language to write; one language to teach/master; one language to rule them all!
# * common functions available to node/js/coffee also available in templates i.e. require() and executed in same scope
# * its eliminating all the intermediary steps between the initial precompilation syntax sugar and the end result
#   i see this as the simplification of stylus + mincer + coffeecup
#   they could all be MUCH smaller, faster, and simpler as one solution or separate parts
#     (i.e.,
#
#       javascript engine compiles .styl files to .css markup (slowly)
#       gaze generates css sprite images (speed depends on stylus)
#       gaze aggregates .css, minifies, gzips it (speed depends on stylus)
#
#       vs.
#
#       coffee engine compiles .coffee files to a single application.css file (fast!)
#         and at the same time, (optionall) generates css sprite images with presence of coffee-sprites lib
#         and at the same time, minifies, and gzips it
#     )
#
# there's not as much room for economy in this example but it would all be faster
# simply if stylus was faster. it all hinges on stylus in a potentially bad way
#
# cons are:
# * the potentially ugly initial template language
# * may be less interesting to write than pure css of the end output which is more understandable, but repetitive
# * in the end, going to great lengths to avoid manually closing brackets and semi-colons and memorizing cross-browser css hacks
```

## See also:

* Works well with [CoffeeTemplates](https://github.com/mikesmullin/coffee-templates)
* Has a plugin called [CoffeeSprites](https://github.com/mikesmullin/coffee-sprites)
