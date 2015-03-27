import md5, os

type FileDB* = string

proc newDB*(dir: string): FileDB =
  if not dirExists(dir): createDir(dir)
  return FileDB(dir)

proc put*(db: FileDB, key, value: string) =
  let hash = getMD5(key)
  var path = string(db)
  for i in 0..7:
    path.add(DirSep & hash[i*4..i*4+3])
    if i!=7:
      if not dirExists(path): createDir(path)
    else:
      writeFile(path, value)

proc get*(db: FileDB, key: string): string =
  let hash = getMD5(key)
  var path = string(db)
  for i in 0..7:
    path.add(DirSep & hash[i*4..i*4+3])
  if fileExists(path):
    return readFile(path)
  else:
    return ""

proc del*(db: FileDB, key: string) =
  let hash = getMD5(key)
  var path = string(db)
  for i in 0..7:
    path.add(DirSep & hash[i*4..i*4+3])
  if fileExists(path):
    removeFile(path)

proc keyExists*(db: FileDB, key: string): bool =
  let hash = getMD5(key)
  var path = string(db)
  for i in 0..7:
    path.add(DirSep & hash[i*4..i*4+3])
  return fileExists(path)
