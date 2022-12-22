import regex

SEP_PATTERN = "[{@@@#@@@}]"
SEP_SUB_PATTERN = r'\1[{@@@#@@@}]'

# Pattern for splitting paragraph into sentences
# https://regex101.com/r/LG7pkB/1
SPLIT_PATTERN = r"""
(
    (
        (?!(.+\)))
        |(?<!(\(.+))
    )
    (
        (?!(.+\）))
        |(?<!(\（.+))
    )
    (
        (?!(.+\」))
        |(?<!(\「.+))
    )
    (
        (?<!(i\.e|e\.g|etc\.*|Inc|inc|Ltd|ltd))([.…?!]+)(?=\s)|([。！？\n]+)
    )
)
"""

# Remove spaces and newline characters
SPLIT_PATTERN = SPLIT_PATTERN.replace(" ", "").replace("\n", "")

# Compile SPLIT_PATTERN into regex expression
SPLIT_PATTERN = regex.compile(SPLIT_PATTERN)

def split_paragraph(paragraph):
    """ Split a paragraph into a list of sentences using regular expression """
    sentences = SPLIT_PATTERN.sub(SEP_SUB_PATTERN, paragraph).split(SEP_PATTERN)
    results = []
    for sentence in sentences:
        results.append(sentence)
    return results
