#encoding: utf-8
require 'spec_helper'

describe TinySegmenter do
  subject{ described_class.new }

  describe "#segment" do
    it "tokenizes Japanese text fairly accurately" do
      subject.segment("極めてコンパクトな日本語分かち書きソフトウェアです。").should == \
        ["極めて", "コンパクト", "な", "日本", "語分", "かち", "書き", "ソフトウェア", "です", "。"]
    end

    it "removes any whitespace-only or empty tokens" do
      subject.segment("書かれた 極めて    コンパクト").should_not include("", " ", nil)
    end

    it "removes full-width space (U+3000) tokens" do
      sentence = "すてき！　男性が歌う「夢やぶれて」もいいね。"
      full_width_space = "　"
      sentence.should include(full_width_space)
      subject.segment(sentence).should_not include (full_width_space)
    end

    it "tokenizes interspersed non-Japanese words correctly" do
      subject.segment("TinySegmenterはRubyだけで").should == ["TinySegmenter", "は", "Ruby", "だけ", "で"]
    end

    context "with ignore_punctuation option not set" do
      it "includes punctuation-only tokens" do
        subject.segment("すてき！?　男性が、歌う「夢やぶれて」もいいね。...").should include("。", "！", "?", "、", "「", "」", "...")
      end
    end

    context "with ignore_punctuation option set" do
      it "removes all punctuation-only tokens" do
        subject.segment("すてき！?　男性が、歌う「夢やぶれて」もいいね。...", ignore_punctuation: true).should_not include("。", "！", "?", "、", "「", "」", "...")
      end
    end
  end

  it "has a version" do
    described_class::VERSION.should be_kind_of(String)
  end
end
