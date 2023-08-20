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

#### Scaffold pipeline

This repository contains a scaffold pipeline in order to easily create or destroy the environment.

To create the environment execute the `scaffold` workflow from main chosing the create option. To destroy use the destroy option.

The is also a `vanish` workflow that you destroy everything at the determined chosen time by the schedule configuration
