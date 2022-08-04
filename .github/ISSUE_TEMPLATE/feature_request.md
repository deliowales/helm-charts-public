---
name: Feature request
about: Suggest an idea for this project
title: "[FEATURE] Brief title of the feature you would like"
labels: enhancement
assignees: ''

---

body:
- type: markdown
  attributes:
  value: |
  Thanks for taking the time to fill out this bug report!

- type: textarea
  id: desc
  attributes:
  label: What limitations is this causing?
  description: Give a clear and concise description of what the problem is.
  placeholder:  ex. I'm always frustrated when [...]
  validations:
  required: true

- type: textarea
  id: prop-solution
  attributes:
  label: Desired behaviour
  description: A clear and concise description of what you want to happen.
  validations:
  required: true

- type: textarea
  id: alternatives
  attributes:
  label: Describe any possible solutions you've considered.
  description: A clear and concise description of any alternative solutions or features you've considered. If nothing, please enter `NONE`
  validations:
  required: true

- type: textarea
  id: additional-ctxt
  attributes:
  label: Additional context.
  description: Add any other context or screenshots about the feature request here.
  validations:
  required: false
