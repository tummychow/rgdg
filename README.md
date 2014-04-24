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
$ rgdg.rb | dot -Tpng -o output.png

# dependencies of one gem
$ rgdg.rb -g jekyll

# dependencies of one version of one gem
$ rgdg.rb -g jekyll -v 1.5.0

# dev deps are excluded by default - let's enable them
$ rgdg.rb -D

# versions of the same gem are combined into one node by default - this will split them
$ rgdg.rb -V
```

## Alternatives

rgdg is not the first (or the only) way to draw gem dependencies as a graph. Here are various other approaches to this problem.

- [davidrupp/gemviz](https://github.com/davidrupp/gemviz)
- [bundler viz](http://bundler.io/v1.6/bundle_viz.html)
- [an awk script](http://sharats.me/dependency-graph-of-all-installed-gems.html)

## I have multiple edges between the same two gems!

If you have multiple edges connecting the same pair of gems, that is not a bug. This behavior indicates that there are multiple versions of the parent gem, all of which are dependent on (various versions of) the child gem. Since there are multiple parents, it makes sense, in my opinion, for there to be multiple edges.

For example, suppose I have two versions of yajl-ruby (1.1.0 and 1.2.0). Both these gems have a development dependency on the json gem (1.8.1). So if I invoke this command:

```bash
$ rgdg.rb -g yajl-ruby -D | dot -Tpng -o yajl.png
```

Then I will end up with a graph with two nodes (yajl-ruby and json), and there will be two edges pointing from yajl-ruby to json. This behavior is normal. You can split the versions by adding the `-V` flag, which will remove any parallel edges.

## License

MIT.
