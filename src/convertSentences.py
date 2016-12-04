s = "The ends must justify the means."
s = s.split()
out = '{o, "'
for i in range(len(s)):
  if "end" in s[i].lower() and "the" in s[i-1].lower():
    continue
  if "the" in s[i].lower() and "end" in s[i+1].lower():
    out += '", e, "'+s[i] + " " + s[i+1]+'", o, " '
  else:
    out += s[i] + " "
print(out[:-1]+'"},')