Ruby port of [TinySegmenter.js](http://chasen.org/~taku/software/TinySegmenter/) for tokenizing Japanese text.

### Install

`gem install tiny_segmenter` or add `tiny_segmenter` to your `Gemfile`

### Usage

```ruby
ts = TinySegmenter.new
p ts.segment("今晩は！良い天気ですね")
# => ["今晩", "は", "！", "良い", "天気", "です", "ね"]
```

Input text should be UTF-8 encoded.
