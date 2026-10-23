# Competition Archive Implementation Plan

> Execute in this session with superpowers:executing-plans. Use superpowers:verification-before-completion before publishing and deleting local files.

**Goal:** Preserve the completed competition project on GitHub, document restoration, then remove the local project without a local backup as requested.

**Architecture:** Keep the existing frontend, FastAPI, model bundle and Kesplus SQL intact. Store the user-supplied models.zip through Git LFS as the sole current model artifact. Exclude credentials and reproducible runtime output. Preserve unique competition and deployment materials outside temporary directories.

**Tech Stack:** Vue 3, Kesplus 3.2, FastAPI, Kingbase, LightGBM, Git.

## Tasks

- [x] Inspect git status, remote, existing docs, API loading, model hashes and local-only files.
- [x] Add ignore rules and LFS ZIP attributes; remove embedded SQL credentials before staging.
- [x] Preserve only the minimal hosted-model example; omit competition slides and temporary extracted materials per user instruction.
- [x] Rewrite README and backend setup docs; record archive contents, restoration prerequisites and verification limits.
- [x] Run existing Node tests, frontend build, Python tests for both API sources, and actual model inference.
- [x] Review staged contents for credentials, binary sizes, missing files and unrelated changes.
- [x] Commit and fast-forward the remote default branch without overwriting remote changes.
- [x] Clone from GitHub, download models.zip, compare tracked contents and ZIP/model hashes, rerun portable checks.
- [x] Record verified remote revision and cleanup intent in the repository.
- [ ] Check exact deletion path, links and processes; remove only the authorized project directory and verify absence.

## User decision

The user explicitly declined a local backup on 2026-10-23. The cleanup target is `D:\kesplusProject\EMDMP`; external installations, databases and other projects are outside scope.
