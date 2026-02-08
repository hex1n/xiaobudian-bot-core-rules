# Deep Evaluation: `qmd` (Query Markup Documents)

**Status:** COMPLETE
**Verdict:** `qmd` is a **Local Hybrid Search Engine**, NOT a task queue.

## 1. What is `qmd`?
*   **Name:** Query Markup Documents.
*   **Purpose:** "An on-device search engine for everything you need to remember."
*   **Core Function:** Indexes local folders (markdown, docs, transcripts) and provides high-quality search using a hybrid approach.
*   **Architecture:**
    *   **Local-First:** Runs entirely on-device using `node-llama-cpp` and GGUF models.
    *   **Hybrid Search:** Combines **BM25** (keyword) + **Vector Search** (semantic) + **LLM Re-ranking**.
    *   **Agent-Ready:** Designed with `--json` and `--files` outputs specifically for AI agents/MCP.

## 2. Feature Deep Dive

### Search Capabilities
*   **Keyword Search (`qmd search`)**: Uses SQLite FTS5 with BM25. Fast, exact matching.
*   **Semantic Search (`qmd vsearch`)**: Uses `embeddinggemma-300M` for vector embeddings. Finds concepts even without exact keywords.
*   **Hybrid Query (`qmd query`)**:
    *   Expands queries using an LLM (Qwen3-1.7B).
    *   Retrieves from both BM25 and Vector indexes.
    *   Fuses results using Reciprocal Rank Fusion (RRF).
    *   Re-ranks top candidates using a Cross-Encoder (Qwen3-Reranker).
    *   *This is SOTA-level search architecture running locally.*

### Knowledge Base Organization
*   **Collections**: You map local directories to named collections (e.g., `~/notes` -> `notes`).
*   **Contexts**: You can attach semantic descriptions to paths (e.g., `qmd://docs` -> "Work documentation"). This helps the search engine understand *what* it is searching.
*   **File Types**: Primarily focuses on Markdown, but can likely index text-based content.

## 3. Comparison for Team 0x01

| Feature | `qmd` | Current `memory_search` | `grep` / `find` |
| :--- | :--- | :--- | :--- |
| **Search Quality** | **Superior** (Hybrid + Rerank) | Good (Semantic only?) | Basic (Exact match) |
| **Speed** | Moderate (Hybrid) / Fast (BM25) | Fast | Very Fast |
| **Context** | Yes (Collection/Path contexts) | Varies | None |
| **Setup** | Requires `bun`, models (~2GB) | Built-in | Built-in |
| **Agent Integration**| Excellent (JSON/MCP support) | Good | Manual parsing |

## 4. Recommendation
**Adopt `qmd` for knowledge retrieval.**
It is significantly more powerful than simple `grep` or standard vector search because of the **re-ranking** step, which drastically reduces hallucinations/irrelevant results for complex queries.

### Integration Plan
1.  Install: `bun install -g github:tobi/qmd`
2.  Index key directories: `qmd collection add ./knowledge --name kb`
3.  Use in agents: Replace `grep` calls with `qmd query "..." --json` for deep research tasks.
