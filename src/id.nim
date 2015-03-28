import tables

var chrList = initTable[int8, char]()
chrList[0]='0'
chrList[1]='1'
chrList[2]='2'
chrList[3]='3'
chrList[4]='4'
chrList[5]='5'
chrList[6]='6'
chrList[7]='7'
chrList[8]='8'
chrList[9]='9'
chrList[10]='a'
chrList[11]='b'
chrList[12]='c'
chrList[13]='d'
chrList[14]='e'
chrList[15]='f'
chrList[16]='g'
chrList[17]='h'
chrList[18]='i'
chrList[19]='j'
chrList[20]='k'
chrList[21]='l'
chrList[22]='m'
chrList[23]='n'
chrList[24]='o'
chrList[25]='p'
chrList[26]='q'
chrList[27]='r'
chrList[28]='s'
chrList[29]='t'
chrList[30]='u'
chrList[31]='v'
chrList[32]='w'
chrList[33]='x'
chrList[34]='y'
chrList[35]='z'
chrList[36]=' '

var intList = initTable[char, int8]()
intList['0']=0
intList['1']=1
intList['2']=2
intList['3']=3
intList['4']=4
intList['5']=5
intList['6']=6
intList['7']=7
intList['8']=8
intList['9']=9
intList['a']=10
intList['b']=11
intList['c']=12
intList['d']=13
intList['e']=14
intList['f']=15
intList['g']=16
intList['h']=17
intList['i']=18
intList['j']=19
intList['k']=20
intList['l']=21
intList['m']=22
intList['n']=23
intList['o']=24
intList['p']=25
intList['q']=26
intList['r']=27
intList['s']=28
intList['t']=29
intList['u']=30
intList['v']=31
intList['w']=32
intList['x']=33
intList['y']=34
intList['z']=35

proc addOne*(s: string): string =
  if s[0] == 'z':
    result = '0' & s
  else:
    result = s
  let rLen = result.len

  result[rLen-1] = chrList[intList[result[rLen-1]]+1]

  for i in countdown(rLen-1, 0):
    if result[i] == ' ':
      result[i] = '0'
      result[i-1] = chrList[intList[result[i-1]]+1]
    else:
      return
