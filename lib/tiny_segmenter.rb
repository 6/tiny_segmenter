#encoding: utf-8
require "tiny_segmenter/version"
require "tiny_segmenter/segmentation_model"

class TinySegmenter
  WhitespaceOnlyRegex = Regexp.compile("^[　 ]+$")
  PunctuationRegex = Regexp.compile("^[-–—―.。・（）()［］｛｝{}【】⟨⟩、､,，،…‥〽「」『』〜~！!：:？?\"'|_＿“”‘’;/⁄／«»]+$")

  def initialize
    @chartype = []
    @model = SegmentationModel.new
    @BIAS = -332
    # Compile regex patterns
    {
      "[一二三四五六七八九十百千万億兆]" => "M", # numbers (japanese)
      "[一-龠々〆ヵヶ]" => "H", # kanji & misc characters
      "[ぁ-ん]" => "I", # hiragana
      "[ァ-ヴーｱ-ﾝﾞｰ]" => "K", # katakana
      "[a-zA-Zａ-ｚＡ-Ｚ]" => "A", # ascii / romaji letters
      "[0-9０-９]" => "N", # ascii / romaji numbers
    }.each do |pattern, value|
      @chartype << [Regexp.compile(pattern), value]
    end
  end

  def segment(text, options = {})
    return []  if text.nil? || text.strip.empty?
    text = text.strip
    result = []
    segments = %w[B3 B2 B1]
    ctypes = %w[O O O]
    text.split(//).each do |char|
      char.strip!
      next  if char.empty? || char.match(WhitespaceOnlyRegex)
      next  if options[:ignore_punctuation] && char.match(PunctuationRegex)
      segments << char
      ctypes << ctype(char)
    end
    segments.concat(%w[E1 E2 E3])
    ctypes.concat(%w[O O O])

    word = segments[3]
    p1, p2, p3 = %w[U U U]
    (4..segments.size-4).to_a.each do |i|
      score = @BIAS
      words = []
      chars = []
      (-3..2).to_a.each do |idx|
        words << segments[i + idx]
        chars << ctypes[i + idx]
      end

      score += sum_scores(p1, p2, p3, *words, *chars)
      p_new = "O"
      if score > 0
        result << word
        word = ""
        p_new = "B"
      end
      p1, p2, p3 = p2, p3, p_new
      word = "#{word}#{segments[i]}"
    end
    result << word  unless word.empty?
    result
  end

  private

  def ctype(str)
    @chartype.each do |pattern, value|
      return value  if str.match(pattern)
    end
    "O"
  end

  def sum_scores(p1, p2, p3, w1, w2, w3, w4, w5, w6, c1, c2, c3, c4, c5, c6)
    score = 0
    [
      [:UP1, p1], [:UP2, p2], [:UP3, p3],
      [:BP1, p1, p2], [:BP2, p2, p3],
      [:UW1, w1], [:UW2, w2], [:UW3, w3], [:UW4, w4], [:UW5, w5], [:UW6, w6],
      [:BW1, w2, w3], [:BW2, w3, w4], [:BW3, w4, w5],
      [:TW1, w1, w2, w3], [:TW2, w2, w3, w4], [:TW3, w3, w4, w5], [:TW4, w4, w5, w6],
      [:UC1, c1], [:UC2, c2], [:UC3, c3], [:UC4, c4], [:UC5, c5], [:UC6, c6],
      [:BC1, c2, c3], [:BC2, c3, c4], [:BC3, c4, c5],
      [:TC1, c1, c2, c3], [:TC2, c2, c3, c4], [:TC3, c3, c4, c5], [:TC4, c4, c5, c6],
      [:UQ1, p1, c1], [:UQ2, p2, c2], [:UQ3, p3, c3],
      [:BQ1, p2, c2, c3], [:BQ2, p2, c3, c4], [:BQ3, p3, c2, c3], [:BQ4, p3, c3, c4],
      [:TQ1, p2, c1, c2, c3], [:TQ2, p2, c2, c3, c4], [:TQ3, p3, c1, c2, c3], [:TQ4, p3, c2, c3, c4],
    ].each do |category_and_pattern|
      category = category_and_pattern[0]
      pattern = category_and_pattern[1..-1].join("")
      score += @model.score(category, pattern)
    end
    score
  end
end
