---
name: Clean-up
about: Execute `terraform destroy`, removing all resources
title: Clean-up
labels: destroy
assignees: []
---

**Description**

Run `terraform destroy` to remove all resources.

**Suggested steps**

- Check the state: `terraform state list`
- Back up the remote state (if applicable)
- Run `terraform destroy` (add `-auto-approve` if you want automation)

**Checklist**

- [ ] I have backed up the state
- [ ] I understand this action is irreversible
- [ ] I ran `terraform destroy` and confirmed resources were removed

> Note: Use with caution — this operation deletes cloud infrastructure.
