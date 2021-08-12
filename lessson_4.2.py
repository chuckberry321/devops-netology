#!/usr/bin/env python3

import os, sys

bash_command = ["cd " + sys.argv[1], "git status"]
result_os = os.popen(' && '.join(bash_command)).read()
is_change = False
for result in result_os.split('\n'):
       if result.find('modified') != -1:
           prepare_result = result.replace('\tmodified:   ', sys.argv[1])
           print(prepare_result)
