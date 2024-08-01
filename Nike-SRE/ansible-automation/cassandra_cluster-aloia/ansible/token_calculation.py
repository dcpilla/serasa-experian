from __future__ import print_function
import argparse
import sys


def main():
    if sys.version_info < (3, 0):
        parser = argparse.ArgumentParser()
        parser.add_argument('--num_tokens', "-t", type=int, default=16,
                           help="Quantidade de Tokens a serem geradas default: 16")
        parser.add_argument('--num_instances', "-i", type=int, default=4,
                           help="Quantidade de instancias default: 4")
        args = parser.parse_args()

        print("\n\n".join(['[Node {}] initial_token: {}'.format(r + 1, ','.join([str(((2**64 / (args.num_tokens * args.num_instances)) * (t * args.num_instances + r))-2**63) for t in range(args.num_tokens)])) for r in range(args.num_instances)]))

    else:
        print("Necessario executar com Python 2! Se voce nao tem, gerei alguns no arquivo tokens.cass")

    return 0

#num_tokens = 16
# Numero de instancias
num_racks = 6

#print("\n\n".join(['[Node {}] initial_token: {}'.format(r + 1, ','.join([str(((2**64 / (num_tokens * num_racks)) * (t * num_racks + r))-2**63) for t in range(num_tokens)])) for r in range(num_racks)]))

if __name__ == '__main__':
    sys.exit(main())
