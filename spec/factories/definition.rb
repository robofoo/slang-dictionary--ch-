# encoding: UTF-8

FactoryGirl.define do
  factory :definition do
    word '看着办'
    pinyin_original 'kan4 zhe4 ban4'
    definition '着个词的意思跟看情况差不多一样。你好我是美国人我的中文不太好。'
    example "A:我不知到怎么办才好。 \r\nB:别紧张，看着办把。"
    email 'factory@factory.com'
    status 'raw'
  end
end
