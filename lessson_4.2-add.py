#!/usr/bin/env python3

import sys, github
from github import Github
if len(sys.argv) > 1 and sys.argv[1] != "":
    pull_request = sys.argv[1]
else:
    print("Pell Request message is not defined!")
    exit(-1)
repo = "devops-netology"
git = Github("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")
repo = git.get_user().get_repo(repo)
print("Pull request " + str(repo) + ". Message: " + pull_request)     
repo.create_pull(title="Pull Request", body=pull_request, head="HW4.3", base="main")
