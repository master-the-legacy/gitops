# Master The Legacy Project

## Overview

Welcome to the Master The Legacy Project! In this collaborative effort, two enthusiastic colleagues come together to tackle the challenge of transforming a dated legacy infrastructure into a cutting-edge next-generation environment. This project is designed not only to learn and practice new technologies but also to apply best practices in the field of DevOps, Cloud Engineering, and Site Reliability Engineering.


### Branch strategy

#### Release flow

- Base branch: `main`
- Feature branch: `feature/*`
- Fix branch: `fix/*`

1. For a new feature:
- Create a new branch from `main` to `feature/<feature-name>` `git checkout -b feature/<feature-name>`
- Once the feature is complete and tested, a new PR should be created to merge back to `main` `gh pr create`

2. For bug fix:
- Create a new branch from `main` to `fix/<fix-name>` `git checkout -b fix/<fix-name>`
- After the fix is implemented and tested, a new PR should be created to merge back to `main` `gh pr create`


Terrible representation
```
feature/specific-feature-name------\
                                   \
                                    \
                                     \
main --------------------------------\
                                     /
                                    /
                                   /
fix/specific-fix-name---------------/

```

### Infrastructure

#### Scaffold pipeline

This repository contains a scaffold pipeline in order to easily create or destroy the environment.

To create the environment execute the `scaffold` workflow from main chosing the create option. To destroy use the destroy option.

The is also a `vanish` workflow that you destroy everything at the determined chosen time by the schedule configuration

#### Local terraform

To plan apply using locally terraform follow the basic terraform workflow, example:

```bash
# For any modification, always format
terraform fmt

# Init
terraform init

# Validate the code
terraform validate

# Select the desired workspace
terraform workspace select <environment>

# Plan
terraform plan -out plan.out # TBD, in order to differ environments --var-file=<env>.tfvars. Is there a way we can use terraform.workspace to do more complex logic ?

# Apply
terraform apply plan.out # TBD, --var-file=<env>.tfvars
```

### EKS

#### Connecting to the cluster

Configuring kubernetes context
```bash
aws eks update-kubeconfig --name "<env>-master-cluster"
```

To test connection `kubectl get svc`