import re

text = 'abbaaabbbbaaaaa'

pattern = 'ab'
pattern1 = 'ab+'
pattern2 = 'ab{2,3}'
pattern3 = 'a[ab]'

# findall() function returns all of the substrings of the input that match the pattern without overlapping.
for match in re.findall(pattern, text):
    print '!Found "%s"' % match

#finditer() returns iterator of match instances

for match in re.finditer(pattern, text):
	s = match.start()
	e = match.end()
	print 'Found %s at %d:%d' %(text[s:e], s, e)

patterns = ['this', 'that']
text1 = 'Does this text match the pattern'

for pattern in patterns:
    if re.search(pattern, text1):
        print 'found a match'
    else:
        print 'no match'
