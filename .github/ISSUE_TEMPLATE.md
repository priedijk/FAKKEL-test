---
title: Resource drift detected in hub-foundation ({{ date | date('dddd, MMMM Do') }})
labels: bug
assignees: 
---
Terraform resource drift detected in on date {{ date | date('dddd, MMMM Do') }}. Please check
[Failed Run](https://github.com/${{ github.repository }}/actions/runs/${{ github.run_id }})
[Codebase](https://github.com/${{ github.repository }}/tree/${{ github.sha }})
Workflow name - ${{ github.workflow }}
Job -           ${{ github.job }}
status -        ${{ job.status }}
Just click this link! https://{{ repo.owner }}.github.io/{{ repo.repo }}/path/to/my/pageindex.html