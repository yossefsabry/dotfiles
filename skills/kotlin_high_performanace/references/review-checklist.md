# Kotlin Performance Review Checklist

Use this file when reviewing Kotlin/JVM code for performance-sensitive work.

## 1. Measurement

- Is there a benchmark, profile, trace, or reproducible measurement?
- Is the claimed bottleneck actually measured?
- Are before and after numbers comparable?
- Is the improvement real enough to justify the added complexity?

## 2. Hot-path work

- Is this code actually hot, or merely suspected to be hot?
- Are there repeated allocations, copies, boxing, or temporary objects?
- Are ranges, regexes, formatters, or builders recreated inside tight loops?
- Is there unnecessary logging or string building on the fast path?

## 3. Collections and pipelines

- Does this pipeline allocate intermediate collections unnecessarily?
- Would a direct loop be materially cheaper and still maintainable?
- Is `asSequence()` removing work, or just adding overhead?
- Does the pipeline short-circuit, or does it always consume everything?

## 4. Memory and lifetime

- Are subscriptions, jobs, or callbacks cancelled when owners die?
- Are closeable resources wrapped in `use` or equivalent deterministic cleanup?
- Are mutable objects being used as map or set keys?
- Is cached data bounded and invalidated correctly?

## 5. Concurrency

- Is the parallel work truly independent?
- Is parallelism bounded to a sensible level?
- Is shared mutable state protected by ownership or safe synchronization?
- Does the "faster" version remain correct under contention and cancellation?
- Are blocking calls happening in the wrong context?

## 6. API and abstraction cost

- Is this abstraction on the hot path?
- Would inlining, hoisting, or a specialized loop remove measurable overhead?
- Did the change add framework or coordination layers without a measured benefit?

## 7. Reporting format

When writing findings, prefer this structure:

1. Measured issue or highest-confidence risk
2. Why it is expensive
3. Recommended smaller change
4. What should be measured next

Separate measured facts from informed inference. If no benchmark exists, say that directly.
