---
title: Resource drift detected in hub-foundation ({{ date | date('dddd, MMMM Do') }})
labels: bug
assignees: 
---
Terraform resource drift detected in on date {{ date | date('dddd, MMMM Do') }}. Please check
[Failed Run](https://github.com/{{ repo.owner }}/{{ repo.repo }}/actions/runs/{{ env.RUN_ID }})
[Codebase](https://github.com/{{ repo.owner }}/{{ repo.repo }}/tree/{{ sha }})

Workflow name - {{ workflow }}
Job -           {{ ref }}
status -        {{ event }}
Just click this link! https://{{ repo.owner }}.github.io/{{ repo.repo }}/path/to/my/pageindex.html