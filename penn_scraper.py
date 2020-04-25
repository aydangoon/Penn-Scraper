#!/usr/bin/python3
from argparse import ArgumentParser
import urllib.request
import os

def parse_args():

    parser = ArgumentParser(description='')

    parser.add_argument('department', type=str, help='the department of the class')
    parser.add_argument('classId', type=int, help='the class number')
    parser.add_argument('-q', action='store_true', default=False, help='show instructor and class quality')
    parser.add_argument('-d', action='store_true', default=False, help='show class difficulty and workload')
    parser.add_argument('-r', action='store_true', default=False, help='show requirements the class fulfills')
    parser.add_argument('-p', action='store_true', default=False, help='show class prerequisites')
    parser.add_argument('-c', action='store_true', default=False, help='show staff contacts')

    return parser.parse_args()


if __name__ == '__main__':

    args = parse_args()
    options = str(args.q) + ' ' + str(args.d) + ' ' + str(args.r) + ' ' + str(args.p) + ' ' + str(args.c)

    #TODO: replace echo with getClassInfo.sh
    os.system('echo ' + args.department + ' ' + str(args.classId) + ' ' + options)
