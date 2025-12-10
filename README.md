# CI/CD Pipeline with GitHub Actions and OpenShift Pipelines

This project demonstrates a CI/CD pipeline using:

- GitHub Actions for linting and unit testing
- Tekton tasks for OpenShift Pipeline integration
- OpenShift for deployment and pipeline execution

## Project Structure

- `.github/workflows/workflow.yml` → GitHub Actions pipeline
- `.tekton/tasks.yml` → Tekton tasks for cleanup and tests
- `app/` → Python application code
- `tests/` → Unit tests
- `screenshots/` → OpenShift and GitHub screenshots

## Instructions

1. Push the repository to GitHub.
2. Run GitHub Actions workflow to validate linting and tests.
3. Deploy pipeline on OpenShift and verify PVC, pipeline run, and logs.
4. Replace screenshot placeholders with actual screenshots.
