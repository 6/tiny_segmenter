#encoding: utf-8
# TODO: Replace this with better tests
require './tiny_segmenter'

ts = TinySegmenter.new
p ts.segment("TinySegmenterはJavascriptだけ書かれた極めてコンパクトな日本語分かち書きソフトウェアです。 わずか25kバイトのソースコードで、日本語の新聞記事であれば文字単位で95%程度の精度で分かち書きが行えます。 Yahoo!の形態素解析のように サーバーサイドで解析するのではなく、全てクライアントサイドで解析を行うため、セキュリティの 観点から見ても安全です。分かち書きの単位はMeCab + ipadicと互換性があります。")
