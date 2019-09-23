import random
import os
import re

patterns = [
    r'^/lfs.*'
]
compiled_patterns = [ re.compile(pattern) for pattern in patterns ]

def path_ignored(path):
    return any([pattern.match(path) for pattern in compiled_patterns ])

def cwd_ignored(pl, segment_info, mode):
	'''Returns True if
	'''
	curpath = segment_info['shortened_path']
	curpath = os.path.expanduser(curpath)
	return path_ignored(curpath)
