import re

text = 'abbaaabbbbaaaaa'

pattern = 'ab'

# findall() function returns all of the substrings of the input that match the pattern without overlapping.
for match in re.findall(pattern, text):
    print '!Found "%s"' % match

#finditer() returns iterator of match instances

for match in re.finditer(pattern, text):
	s = match.start()
	e = match.end()
	print 'Found %s at %d:%d' %(text[s:e], s, e)
