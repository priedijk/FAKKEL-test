---
title: Resource drift detected in hub-foundation ({{ date | date('dddd, MMMM Do') }})
labels: bug
assignees: 
---
Terraform resource drift detected in on date {{ date | date('dddd, MMMM Do YYYY, HH:mm') }}. Please check the detected changes in the [Workflow run](https://github.com/{{ repo.owner }}/{{ repo.repo }}/actions/runs/{{ env.RUN_ID }})
* Check detected changes in workflow run
* Investigate who made the changes in Azure
* Communicate to Actor


[Failed Run](https://github.com/{{ repo.owner }}/{{ repo.repo }}/actions/runs/{{ env.RUN_ID }})
[Codebase](https://github.com/{{ repo.owner }}/{{ repo.repo }}/tree/{{ sha }})

Workflow name - {{ workflow }}
Job -           {{ ref }}
status -        {{ event }}