# Attack Tree

## Goal: [Root Goal]

```mermaid
graph TD
    Root[Root Goal] --> OR1[Sub-Goal 1]
    Root --> OR2[Sub-Goal 2]
    OR1 --> AND1[Step 1.1]
    OR1 --> AND2[Step 1.2]
    OR2 --> Step2_1[Step 2.1]
    AND1 --> Leaf1[Leaf Action 1]
    AND1 --> Leaf2[Leaf Action 2]
    AND2 --> Leaf3[Leaf Action 3]
    Step2_1 --> Leaf4[Leaf Action 4]
```

## Leaf Node Analysis

| Leaf Node | Difficulty | Detection | Impact | Mitigation |
|-----------|------------|-----------|--------|------------|
| Leaf Action 1 | | | | |
| Leaf Action 2 | | | | |