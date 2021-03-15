import sys
import json
import libpyfeature_extract

fe = libpyfeature_extract.PyFeatureExtract('')
def generator(data, kvs, seq_kvs):
    x = fe.extract(data)
    obj = json.loads(x)
    for k, v in obj.get('int_features', {}).items():
        if k not in kvs:
            kvs[k] = {}
        if v not in kvs[k]:
            kvs[k][v] = 0
        kvs[k][v] += 1
    for k, v in obj.get('sequence_features', {}).items():
        if k not in seq_kvs:
            seq_kvs[k] = {}
        v = v[0]
        if v not in seq_kvs[k]:
            seq_kvs[k][v] = 0
        seq_kvs[k][v] += 1

def generato1r(data):
    pass


if __name__ == '__main__':
    kvs = {}
    seq_kvs = {}

    for line in sys.stdin:
        generator(line, kvs, seq_kvs)

    out = open('feature_index.txt', 'w')
    for k, vs in kvs.items():
        print(k, len(vs), sum(vs.values()), 'sparse')
        out.write('\t'.join([str(x) for x in [k, 0, len(vs) * 10, 'int', 0, 0, 0]]) + '\n')
    for k, vs in seq_kvs.items():
        out.write('\t'.join([str(x) for x in [k, 0, len(vs) * 10, 'sequence', 0, 0, 0]]) + '\n')
        print(k, len(vs), sum(vs.values()), 'sequence')

    out.close()


