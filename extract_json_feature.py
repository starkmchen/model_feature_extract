import libpyfeature_extract
import json
import sys



fe = libpyfeature_extract.PyFeatureExtract('')
for line in sys.stdin:
  print fe.extract(line)
