#!/usr/bin/env python3
from argparse import ArgumentParser
from graphics import *
import tkinter as tk
import tkinter.scrolledtext as tkst

import os

def parse_args():

    parser = ArgumentParser(description='')

    parser.add_argument('department', type=str, help='the department of the class')
    parser.add_argument('classId', metavar='class_ID', type=int, help='the class number')
    parser.add_argument('-s', action='store_false', default=True, help='show simplified display')

    #need API access
    parser.add_argument('-d', action='store_true', default=False, help='show class difficulty and workload')
    parser.add_argument('-r', action='store_true', default=False, help='show requirements the class fulfills')

    parser.add_argument('-p', action='store_true', default=False, help='show class prerequisites')
    parser.add_argument('-c', action='store_false', default=True, help='hide staff contacts')
    parser.add_argument('-g', action='store_true', default=False, help='show GUI display of the results. If off, it ')
    parser.add_argument('-next', action='store_false', default=True, help='show the next semester as well')

    return parser.parse_args()


if __name__ == '__main__':

    args = parse_args()
    options = str(args.s) + ' ' + str(args.c) + ' ' + str(args.p) + ' ' + str(args.next)
    class_name = args.department + ' ' + str(args.classId)

    #raw output of the search
    output = os.popen('./getClassInfo.sh ' + class_name + ' ' + options).read()

    #puts output on GUI if user specified -g
    if (args.g):

        root = tk.Tk()
        root.title("Search Result for " + class_name)
        frame = tk.Frame(root, bg='brown')
        frame.pack(fill='both', expand='yes')
        edit_space = tkst.ScrolledText(
            master = frame,
            wrap   = 'word',
            width  = 400,
            height = 600,
            bg='beige'
        )

        edit_space.pack(fill='both', expand=True, padx=8, pady=8)
        edit_space.insert('insert', output)
        root.mainloop()

        root.mainloop()

    else:
        print(output)
