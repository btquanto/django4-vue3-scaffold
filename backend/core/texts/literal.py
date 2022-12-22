import regex

# Pattern for meaningless or unimpactful texts
# pylint: disable=line-too-long
NONSENSE_PATTERN = regex.compile(
    r'^(([`\s\-=~!@#$%^&*()_+\[\]\\;\',.\/{}|:"“”<>?｀０-９ー＝〜！＠＃＄％＾＆＊（）＿＋「」￥；’、。・『』｜：”＜＞？])*|([A-Za-z]\.|\(([xvi]{1,4}|[XVI]{1,4})\)|([xvi]{1,4}|[XVI]{1,4})\.|…|\n)|([A-Za-z\s]{1,4}))$'
)

def has_meaning(sentence):
    """ Return if this sentence is meaningful"""
    return sentence and NONSENSE_PATTERN.match(sentence) is None
