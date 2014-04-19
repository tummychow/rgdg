# rgdg - RubyGems Dependency Grapher

rgdg is a Ruby script that draws graphs of the dependencies for your installed gems. Output is in [Graphviz DOT format](http://www.graphviz.org/content/dot-language), and can be piped directly into dot to make images.

The script targets Ruby 2.1.1 (MRI) and RubyGems 2.2.2. I don't make any provisions for supporting any other platform, and I will probably update the script aggressively to stay in line with the most recent Ruby/RubyGems versions. PRs to improve support for other Ruby implementations are welcome.

## Features

- can exclude development dependencies from the graph
- can draw separate nodes for separate versions of a gem
- can draw dependencies for all gems, one gem, or one version of one gem
- no dependencies outside the Ruby standard library
- uses RubyGems API rather than shell invocations of the gem command

## Installation

Download the script and run it. That's all. rgdg is not (and will *never* be) installable via `gem install`. The last thing you need when you're trying to sort out your local gems is... having to install another gem.

## Usage

```bash
# dependencies of all gems
# in further examples, the pipe to dot will be omitted
$ rgdg | dot -Tpng -o output.png

# dependencies of one gem
$ rgdg -g jekyll

# dependencies of one version of one gem
$ rgdg -g jekyll -v 1.5.0

# dev deps are excluded by default - let's enable them
$ rgdg -D

# versions of the same gem are combined into one node by default - this will split them
$ rgdg -V
```

## Alternatives

rgdg is not the first (or the only) way to draw gem dependencies as a graph. Here are various other approaches to this problem.

- [davidrupp/gemviz](https://github.com/davidrupp/gemviz)
- [bundler viz](http://bundler.io/v1.6/bundle_viz.html)
- [an awk script](http://sharats.me/dependency-graph-of-all-installed-gems.html)

## License

MIT.
