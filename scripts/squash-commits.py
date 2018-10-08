#!/usr/bin/env python3
import argparse
import re
import sys
from contextlib import contextmanager

def normalize_commit(commit, fixed_length=7):
   if len(commit) < fixed_length:
      raise Exception('Commit ' + commit + ' does not satisfy min length of ' + str(fixed_length))
   return commit[:fixed_length]


# check invariants on commits (e.g. same length, min length),
# and cut down to prefix of fixed length
def preprocess_commits(commits, fixed_length=7):
   result = []
   common_length = None
   for commit in commits:
      length = len(commit)
      if common_length:
         assert(length == common_length)
      else:
         common_length = length
      result.append(normalize_commit(commit))

   return result


# given an ordered list of lines of a git rebase file and a set of commits to
# be squashed, returns the modified resulting lines
def process_lines(lines, commits):
   commits = preprocess_commits(commits)
   commits_to_be_squashed = frozenset(commits)
   # we use this to keep track that all commits occur exactly once
   commits_to_be_found = set(commits)
   pick_re = re.compile('^pick (?P<c_hash>[0-9a-f]+) (?P<c_msg>.+)$')
   block_before_squash = []
   block_squash = []
   block_after_squash = []

   # this is the 'active' block not corresponding to the squash part
   # will point to block_after_squash after we encounter the first commit to be squashed
   non_squash_block = block_before_squash

   def squashed_commit(line):
      m = pick_re.match(line)
      if not m:
         return None
      else:
         commit = normalize_commit(m.groupdict()['c_hash'])
         if commit not in commits_to_be_squashed:
            return None
         return commit

   for line in lines:
      commit = squashed_commit(line)
      if commit is None:
         block = non_squash_block
      else:
         non_squash_block = block_after_squash
         commits_to_be_found.remove(commit)
         block = block_squash
         if block:
            line = line.replace("pick", "squash", 1)
      block.append(line)

   if commits_to_be_found:
      raise Exception(str(len(commits_to_be_found)) + ' commits not found, e.g.: ' + commits_to_be_found.pop())

   return block_before_squash + block_squash + block_after_squash

# Wrapper routine to either read a file or read from stdin
@contextmanager
def open_file(filename):
   if not filename and sys.stdin.isatty():
      raise Exception('If no rebase file provided, you need to pass via stdin!')
   if filename:
      f = open(filename, 'r')
   else:
      f = sys.stdin
   try:
       yield f
   finally:
      if filename:
         f.close()

# return file as list of lines
def read_file(filename):
   with open_file(filename) as opened_file:
      return [ line for line in opened_file ]

# write given lines into filename, overwriting any existing content
def write_file(filename, lines):
   with open(filename, 'w') as opened_file:
      for line in lines:
         opened_file.write(line)

def process_file(*, rebase_file, commits):
   #print("Rebase file: " + rebase_file)
   #print("Commits: " + ", ".join(commits))

   input_lines = read_file(rebase_file)
   new_lines = process_lines(input_lines, commits)
   for line in new_lines:
      print(line, end='')
   #write_file(rebase_file, new_lines)


def main():
   parser = argparse.ArgumentParser(description='Prints a modified git rebase file s.t. a given set of commits C1, ... is sqashed into the oldest of C1, ...')
   parser.add_argument('--rebase-file', type=str, help='Rebase file to be read.')
   parser.add_argument('--commits', type=str, nargs='+', help='The hashed of commits to be sqashed', required=True)

   args = parser.parse_args()

   process_file(**args.__dict__)

if __name__ == "__main__":
    main()
