#! /usr/bin/env python
#

import string, sys, re, os, glob

# All dirs: check MANIFEST vs. files

subdirs = [
  'idlac',
  'cos/event',
  'cos/naming',
  'cos/time',
  'examples/all_functions',
  'examples/all_types',
  'examples/echo',
  'examples/generic',
  'examples/module',
  'examples/random'
  ]

def read_MANIFEST (dir):
  MANIFEST = []
  for l in open ("MANIFEST", "r").readlines ():
    m = re.match ("^(" + dir + "/.*\.ad[sb])$", l)
    if m:
      MANIFEST.append (m.group (1))
  return MANIFEST

def read_files (dir):
  return glob.glob (dir + "/*.ad[sb]")

# Additional checks for src/:
#  Makefile.am
#  allsrc

def read_Makefile ():
  Makefile = []
  st = 0
  for l in open ("src/Makefile.am", "r").readlines ():
    if re.match ("^ADA_SPECS_WITH_BODY =", l):
      st = 2
      continue
    if re.match ("^ADA_SPECS =", l):
      st = 1
      continue
    if re.match ("^$", l):
      st = 0
      continue
    if st > 0:
      m = re.match ("^\s*(\S*\.ad)[sb]", l)
      if m:
        Makefile.append ("src/" + m.group (1) + 's')
        if st > 1:
          Makefile.append ("src/" + m.group (1) + 'b')
          
  return Makefile

alis_seen = []

def read_one_ali (alidir, file):
  
  try:
    f = open (alidir + "/" + file, "r")
  except:
    return []
  
  units = []
  for l in f.readlines ():
    if l[0] == 'U':
      units.append ("src/" + re.match ("^U\s*\S*\s*(\S*\.ad[bs])", l).group (1))
    elif l[0] == 'W':
      m = re.match ("^W\s\S*\s*\S*\s*(\S*\.ali)", l)
      if m:
        ali = m.group (1)
        try:
          i = alis_seen.index (ali)
        except:
          alis_seen.append (ali)
          units = units + read_one_ali (alidir, ali)
  return units

def read_allsrc (alidir):
  return read_one_ali (alidir, "allsrc.ali")

def compare_lists (l1, l2, reverse):
  ll1 = eval (l1)[:]
  ll2 = eval (l2)[:]

  not_in_ll1 = []
  for f in ll2:
    try:
      ll1.remove (f)
    except:
      not_in_ll1.append (f)
        
  if len (ll1) > 0:
    print ("These are in " + l1 + " but not in " + l2 + ":")
    print ("  " + string.join (ll1, "\n  "))
    print ""
    
  if reverse and len (not_in_ll1) > 0:
    print ("These are in " + l2 + " but not in " + l1 + ":")
    print ("  " + string.join (not_in_ll1, "\n  "))
    print ""
    
print "Checking src/...\n"

MANIFEST = read_MANIFEST ("src")
files = read_files ("src")
Makefile = read_Makefile ()

compare_lists ("files", "MANIFEST", 1)
compare_lists ("files", "Makefile", 1)

if len (sys.argv) > 1:
  allsrc = read_allsrc (sys.argv[1])
  compare_lists ("files", "allsrc", 0)

for d in subdirs:
  print "Checking " + d + "/...\n"
  
  MANIFEST = read_MANIFEST (d)
  files = read_files (d)

  compare_lists ("files", "MANIFEST", 1)
