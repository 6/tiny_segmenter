#encoding: utf-8
require 'spec_helper'

describe TinySegmenter do
  subject{ described_class.new }

  describe "#segment" do
    it "tokenizes Japanese text fairly accurately" do
      expect(subject.segment("極めてコンパクトな日本語分かち書きソフトウェアです。")).to \
        eq(["極めて", "コンパクト", "な", "日本", "語分", "かち", "書き", "ソフトウェア", "です", "。"])
    end

    it "removes any whitespace-only or empty tokens" do
      expect(subject.segment("書かれた 極めて    コンパクト")).not_to include("", " ", nil)
    end

    it "removes full-width space (U+3000) tokens" do
      sentence = "すてき！　男性が歌う「夢やぶれて」もいいね。"
      full_width_space = "　"
      expect(sentence).to include(full_width_space)
      expect(subject.segment(sentence)).not_to include (full_width_space)
    end

    it "tokenizes interspersed non-Japanese words correctly" do
      expect(subject.segment("TinySegmenterはRubyだけで")).to \
        eq(["TinySegmenter", "は", "Ruby", "だけ", "で"])
    end

    context "with ignore_punctuation option not set" do
      it "includes punctuation-only tokens" do
        expect(subject.segment("すてき！?　男性が、歌う「夢やぶれて」もいいね。...")).to \
          include("。", "！", "?", "、", "「", "」", "...")
      end
    end

    context "with ignore_punctuation option set" do
      it "removes all punctuation-only tokens" do
        expect(subject.segment("すてき！?　男性が、歌う「夢やぶれて」もいいね。...", ignore_punctuation: true)).not_to \
          include("。", "！", "?", "、", "「", "」", "...")
      end
    end
  end

  it "has a version" do
    expect(described_class::VERSION).to be_kind_of(String)
    expect(described_class::VERSION).not_to be_empty
  end
end
