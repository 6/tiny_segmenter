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
      w1 = segments[i - 3]
      w2 = segments[i - 2]
      w3 = segments[i - 1]
      w4 = segments[i]
      w5 = segments[i + 1]
      w6 = segments[i + 2]
      c1 = ctypes[i - 3]
      c2 = ctypes[i - 2]
      c3 = ctypes[i - 1]
      c4 = ctypes[i]
      c5 = ctypes[i + 1]
      c6 = ctypes[i + 2]

      score += sum_scores(p1, p2, p3, w1, w2, w3, w4, w5, w6, c1, c2, c3, c4, c5, c6)
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
    score += @model.score(:UP1, p1)
    score += @model.score(:UP2, p2)
    score += @model.score(:UP3, p3)
    score += @model.score(:BP1, p1 + p2)
    score += @model.score(:BP2, p2 + p3)
    score += @model.score(:UW1, w1)
    score += @model.score(:UW2, w2)
    score += @model.score(:UW3, w3)
    score += @model.score(:UW4, w4)
    score += @model.score(:UW5, w5)
    score += @model.score(:UW6, w6)
    score += @model.score(:BW1, w2 + w3)
    score += @model.score(:BW2, w3 + w4)
    score += @model.score(:BW3, w4 + w5)
    score += @model.score(:TW1, w1 + w2 + w3)
    score += @model.score(:TW2, w2 + w3 + w4)
    score += @model.score(:TW3, w3 + w4 + w5)
    score += @model.score(:TW4, w4 + w5 + w6)
    score += @model.score(:UC1, c1)
    score += @model.score(:UC2, c2)
    score += @model.score(:UC3, c3)
    score += @model.score(:UC4, c4)
    score += @model.score(:UC5, c5)
    score += @model.score(:UC6, c6)
    score += @model.score(:BC1, c2 + c3)
    score += @model.score(:BC2, c3 + c4)
    score += @model.score(:BC3, c4 + c5)
    score += @model.score(:TC1, c1 + c2 + c3)
    score += @model.score(:TC2, c2 + c3 + c4)
    score += @model.score(:TC3, c3 + c4 + c5)
    score += @model.score(:TC4, c4 + c5 + c6)
    score += @model.score(:UQ1, p1 + c1)
    score += @model.score(:UQ2, p2 + c2)
    score += @model.score(:UQ3, p3 + c3)
    score += @model.score(:BQ1, p2 + c2 + c3)
    score += @model.score(:BQ2, p2 + c3 + c4)
    score += @model.score(:BQ3, p3 + c2 + c3)
    score += @model.score(:BQ4, p3 + c3 + c4)
    score += @model.score(:TQ1, p2 + c1 + c2 + c3)
    score += @model.score(:TQ2, p2 + c2 + c3 + c4)
    score += @model.score(:TQ3, p3 + c1 + c2 + c3)
    score += @model.score(:TQ4, p3 + c2 + c3 + c4)
    score
  end
end
