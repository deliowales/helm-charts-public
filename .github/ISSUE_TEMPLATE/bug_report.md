---
name: Bug report
about: Create a report to help us improve
title: "[BUG] Brief title of bug report"
labels: bug
assignees: ''

---

body:
- type: markdown
  attributes:
  value: |
  Thanks for taking the time to fill out this bug report! Please be cautious with the sensitive information/logs while filing the issue.
- type: textarea
  id: desc
  attributes:
  label: Describe the bug in a clear and concise description of what the bug is.
  validations:
  required: true

- type: input
  id: chart-version
  attributes:
  label: What's the chart version?
  description: Enter the version of the chart that you encountered this bug.
  validations:
  required: true

- type: textarea
  id: how-to-reproduce
  attributes:
  label: How to reproduce it?
  description: As minimally and precisely as possible. Please include the `helm` command you are running.
  validations:
  required: true

- type: textarea
  id: logs-and-output
  attributes:
  label: Relevant Logs/Console Output
  description: As minimally and precisely as possible. Please include the `helm` command you are running.
  validations:
  required: true

- type: textarea
  id: anything-else
  attributes:
  label: Anything else we need to know?
  placeholder: This is affecting service `foo` on environment `bar`
  validations:
  required: false