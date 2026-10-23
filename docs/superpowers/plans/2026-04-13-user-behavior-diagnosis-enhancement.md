# User Behavior Diagnosis Enhancement Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make user behavior diagnosis follow the business report strategy: generate a rule-based draft first, polish it asynchronously with the LLM, and hide the draft while the LLM is still running.

**Architecture:** Keep the existing direct diagnosis endpoint for compatibility, add `start + task polling` endpoints that immediately return the rule draft with `pending` task metadata, and reuse the rule draft as the LLM polishing source. Update the frontend to switch from one-shot generation to start-plus-polling while keeping the diagnosis cards blank except for the blue loading indicator during enhancement.

**Tech Stack:** Vue 3, Kesplus request layer, FastAPI, unittest

---

### Task 1: Add failing API tests

**Files:**
- Modify: `fastapi/tests/test_user_behavior_diagnosis_api.py`

- [ ] Add route registration assertions for `/api/EMDMPAI/generate-user-behavior-diagnosis/start` and `/api/EMDMPAI/generate-user-behavior-diagnosis/tasks/{task_id}`.
- [ ] Add a test asserting the start endpoint returns a fallback report, `enhancementStatus="pending"`, and a task id.
- [ ] Add a test asserting the task endpoint returns stored completed enhancement content.

### Task 2: Implement backend async polish flow

**Files:**
- Modify: `fastapi/apps/EMDMPAI/apis/user_behavior_diagnosis_api.py`

- [ ] Rework diagnosis generation into `fallback_diagnosis` plus `build_polish_prompt`.
- [ ] Add in-memory task storage, async worker, start endpoint, and task query endpoint.
- [ ] Keep the existing direct diagnosis endpoint working by returning the polished result or fallback.

### Task 3: Update frontend diagnosis flow

**Files:**
- Modify: `src/views/ai-module/user-behavior-analysis/utils/user-behavior-analysis-api.js`
- Modify: `src/views/ai-module/user-behavior-analysis/index.vue`

- [ ] Add start and task polling API helpers.
- [ ] Replace the one-shot generate action with start plus polling.
- [ ] Keep diagnosis cards hidden while enhancement is pending, showing only the blue loading indicator and `大模型生成中`.
- [ ] Stop and clear polling when searching again, resetting, switching view type, or leaving the page.

### Task 4: Verify

**Files:**
- Modify: none

- [ ] Run `python -m unittest tests.test_user_behavior_diagnosis_api`.
- [ ] Run `python -m py_compile main.py apps\EMDMPAI\apis\user_behavior_diagnosis_api.py`.
- [ ] Run `npm.cmd run build`.
