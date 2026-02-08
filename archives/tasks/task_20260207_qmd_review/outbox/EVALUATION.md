# Evaluation of `qmd` (Query Markup Documents)

## What is it?
`qmd` is a local, CLI-based search engine designed specifically for Markdown files, utilizing a hybrid approach of full-text search (BM25), vector semantic search, and LLM re-ranking.

## Key Features
*   **Hybrid Search**: Combines traditional keyword search (BM25) with semantic vector search and LLM-based re-ranking for high relevance.
*   **Local & Private**: Runs entirely on-device using `node-llama-cpp` and GGUF models (EmbeddingGemma, Qwen2.5, etc.); no external APIs required.
*   **Agent-Ready**: Outputs results in JSON/structured formats designed for LLM consumption; includes an MCP (Model Context Protocol) server.
*   **Collection Management**: allows grouping files into "collections" (e.g., `notes`, `docs`) with specific contexts.
*   **Context Awareness**: Uses "virtual paths" (`qmd://notes`) to inject semantic descriptions into the search scope.

## Relevance to Team 0x01
**High.**
*   **Workflow Match**: We live in Markdown (`MEMORY.md`, `SKILL.md`, `AGENTS.md`). As these files grow, `grep` or simple text search becomes insufficient for finding *concepts* rather than just *keywords*.
*   **Agent Integration**: The tool is explicitly built for agents. The JSON output and MCP server mean we could integrate it directly into our toolchain to allow agents to "remember" things better by semantically searching our memory archives.
*   **Privacy**: It fits our preference for local/controlled execution without leaking memory contents to third-party search APIs.

## Recommendation
**Adopt (Pilot Phase).**
*   Install `qmd` and index our `memory/` and `skills/` directories.
*   Test replacing simple file reads with `qmd search` for retrieving relevant skills or past memories during complex tasks.
*   It is significantly better than `jq`/`awk` for *retrieval* (finding the right content), whereas `jq`/`awk` are for *processing* (formatting known content). They are complementary, not competing.
