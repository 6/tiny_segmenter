Ruby port of [TinySegmenter.js](http://chasen.org/~taku/software/TinySegmenter/) for tokenizing Japanese text. Ruby 1.9 or higher required.

[![Build Status](https://secure.travis-ci.org/6/tiny_segmenter.png?branch=master)](http://travis-ci.org/6/tiny_segmenter)

### Install

`gem install tiny_segmenter` or add `tiny_segmenter` to your `Gemfile`

### Usage

```ruby
ts = TinySegmenter.new
p ts.segment("今晩は！良い天気ですね")
# => ["今晩", "は", "！", "良い", "天気", "です", "ね"]
```

Input text should be UTF-8 encoded.

### How it works

The Naive Bayes model was trained using the [RWCP corpus](http://research.nii.ac.jp/src/list.html) and optimized using L1-norm regularization (e.g. [this](https://research.microsoft.com/pubs/78900/andrew07scalable.pdf)). The resultant model is quite compact, yet (according to the author) has about a 95% accuracy rate.

### License

BSD - see http://chasen.org/~taku/software/TinySegmenter/LICENCE.txt
