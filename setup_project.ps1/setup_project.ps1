# Set project root
$projectRoot = "C:\Users\admin\Downloads\CI-CD-Pipeline-with-GitHub-Actions-and-Open-Shift-Pipelines"

# Create folders
$folders = @(".github\workflows", ".tekton", "app", "tests", "screenshots")
foreach ($folder in $folders) {
    $fullPath = Join-Path $projectRoot $folder
    New-Item -ItemType Directory -Path $fullPath -Force | Out-Null
}

# Create files with content
$files = @{
    ".github\workflows\workflow.yml" = @"
name: CI/CD Pipeline

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      - name: Install dependencies
        run: pip install flake8 nose
      - name: Lint with flake8
        run: flake8 app/ tests/

  test:
    runs-on: ubuntu-latest
    needs: lint
    steps:
      - uses: actions/checkout@v3
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.10'
      - name: Install dependencies
        run: pip install nose
      - name: Run unit tests with nose
        run: nosetests tests/
"@

    ".tekton\tasks.yml" = @"
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: cleanup-task
spec:
  steps:
    - name: cleanup
      image: busybox
      script: |
        #!/bin/sh
        echo "Cleaning up workspace..."
        rm -rf /workspace/*

---
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: nose-task
spec:
  steps:
    - name: run-tests
      image: python:3.10
      script: |
        #!/bin/sh
        pip install nose
        nosetests /workspace/tests/
"@

    "app\main.py" = @"
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

if __name__ == '__main__':
    print('Add 2+3:', add(2, 3))
    print('Subtract 5-2:', subtract(5, 2))
"@

    "tests\test_main.py" = @"
from app.main import add, subtract

def test_add():
    assert add(2, 3) == 5

def test_subtract():
    assert subtract(5, 2) == 3
"@

    "README.md" = @"
# CI/CD Pipeline with GitHub Actions and OpenShift Pipelines

This project demonstrates a CI/CD pipeline with GitHub Actions and OpenShift Tekton pipelines.
"@
}

foreach ($path in $files.Keys) {
    $fullPath = Join-Path $projectRoot $path
    $content = $files[$path]
    $content | Out-File -FilePath $fullPath -Encoding UTF8 -Force
}

# Create empty screenshot PNG files
$screenshots = @(
    "oc-pipelines-console-pvc-details.png",
    "cicd-github-validate.png",
    "oc-pipelines-oc-final.png",
    "oc-pipelines-oc-green.png",
    "oc-pipelines-app-logs.png"
)

foreach ($s in $screenshots) {
    $fullPath = Join-Path $projectRoot "screenshots\$s"
    New-Item -ItemType File -Path $fullPath -Force | Out-Null
}

# Create ZIP
$zipPath = Join-Path $projectRoot "..\CI-CD-Pipeline.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Compress-Archive -Path $projectRoot\* -DestinationPath $zipPath

Write-Host "Project structure created and zipped at: $zipPath"
