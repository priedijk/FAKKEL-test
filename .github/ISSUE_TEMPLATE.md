---
title: Resource drift detected in hub-foundation ({{ date | date('dddd, MMMM Do') }})
labels: bug
assignees: 
---
Terraform resource drift detected in on date {{ date | date('dddd, MMMM Do YYYY, HH:mm') }}. Please check the detected changes in the [Workflow run](https://github.com/{{ repo.owner }}/{{ repo.repo }}/actions/runs/{{ env.RUN_ID }}

### Actions to take
* Check detected changes in the [Workflow run](https://github.com/{{ repo.owner }}/{{ repo.repo }}/actions/runs/{{ env.RUN_ID }}
* Investigate who made the changes in [Azure](https://portal.azure.com/)
* Communicate to Actor


[Failed Run](https://github.com/{{ repo.owner }}/{{ repo.repo }}/actions/runs/{{ env.RUN_ID }})
[Codebase](https://github.com/{{ repo.owner }}/{{ repo.repo }}/tree/{{ sha }})

All variables
action = {{ action }}
actor = {{ actor }}
event = {{ event }}
payload = {{ payload }}
ref = {{ ref }}
sha = {{ sha }}
workflow = {{ workflow }}
issue.repo = {{ issue.repo }}
issue.owner = {{ issue.owner }}
issue.issue_number = {{ issue.issue_number }}
pullRequest.repo = {{ pullRequest.repo }}
pullRequest.owner = {{ pullRequest.owner }}
pullRequest.pull_number = {{ pullRequest.pull_number }}
repo.repo = {{ repo.repo }}
repo.owner = {{ repo.owner }}

# heading1 example
## heading2 example
### heading3 example
#### heading4 example
##### heading5 example
###### heading6 example