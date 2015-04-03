proc toChr(i: int8): char =
  case i:
  of 0: return '0'
  of 1: return '1'
  of 2: return '2'
  of 3: return '3'
  of 4: return '4'
  of 5: return '5'
  of 6: return '6'
  of 7: return '7'
  of 8: return '8'
  of 9: return '9'
  of 10: return 'a'
  of 11: return 'b'
  of 12: return 'c'
  of 13: return 'd'
  of 14: return 'e'
  of 15: return 'f'
  of 16: return 'g'
  of 17: return 'h'
  of 18: return 'i'
  of 19: return 'j'
  of 20: return 'k'
  of 21: return 'l'
  of 22: return 'm'
  of 23: return 'n'
  of 24: return 'o'
  of 25: return 'p'
  of 26: return 'q'
  of 27: return 'r'
  of 28: return 's'
  of 29: return 't'
  of 30: return 'u'
  of 31: return 'v'
  of 32: return 'w'
  of 33: return 'x'
  of 34: return 'y'
  of 35: return 'z'
  else: return ' '

proc toInt(c: char): int8 =
  case c:
  of '0': return 0
  of '1': return 1
  of '2': return 2
  of '3': return 3
  of '4': return 4
  of '5': return 5
  of '6': return 6
  of '7': return 7
  of '8': return 8
  of '9': return 9
  of 'a': return 10
  of 'b': return 11
  of 'c': return 12
  of 'd': return 13
  of 'e': return 14
  of 'f': return 15
  of 'g': return 16
  of 'h': return 17
  of 'i': return 18
  of 'j': return 19
  of 'k': return 20
  of 'l': return 21
  of 'm': return 22
  of 'n': return 23
  of 'o': return 24
  of 'p': return 25
  of 'q': return 26
  of 'r': return 27
  of 's': return 28
  of 't': return 29
  of 'u': return 30
  of 'v': return 31
  of 'w': return 32
  of 'x': return 33
  of 'y': return 34
  of 'z': return 35
  else: return -1

proc addOne(c: char): char =
  return (c.toInt()+1).toChr()

proc addOne*(s: string): string =
  result = s
  let rLen = result.len

  result[rLen-1] = result[rLen-1].addOne()

  for i in countdown(rLen-1, 0):
    if result[i] == ' ':
      result[i] = '0'
      if i == 0:
        result = '1' & result
      else:
        result[i-1] = result[i-1].addOne()
    else:
      return