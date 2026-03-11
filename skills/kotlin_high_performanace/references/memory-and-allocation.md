# Memory And Allocation

## Goal

Keep object lifetime explicit, avoid accidental retention, and reduce needless allocation in hot code paths.

## What the local sources show

- `reference/Chapter01/memoryLeak/Example1.kt` demonstrates a leak caused by a long-lived Rx subscription retaining object state.
- `reference/Chapter01/memoryLeak/Example2.kt` shows the same pattern with explicit disposal, making ownership and cleanup visible.
- `reference/Chapter01/tryFinally/Example1.kt`, `Example2.kt`, and `Example3.kt` show the progression from missing cleanup to explicit cleanup to idiomatic `use`.
- `reference/Chapter01/memoryLeak/mutableKey/Example1.kt`, `Example2.kt`, and `Example3.kt` show why mutable keys break map behavior and why immutable keys are safer.
- `reference/Chapter01/stringPool/*` shows that string identity and interning are subtle and should not be used casually as a performance trick.
- `reference/Chapter10/immutability/Example1.kt` reinforces that copying immutable data preserves value semantics without shared mutable state.

## Practical rules

- Prefer short-lived ownership and deterministic cleanup.
- Use `use` for closeable resources instead of open-coded cleanup unless you have a specific reason not to.
- Avoid subscriptions, callbacks, or coroutines that outlive the object they capture unless you also define how they are cancelled.
- Prefer immutable keys for maps and sets.
- Prefer immutable state objects when data crosses threads or coroutine boundaries.
- Reduce temporary object creation in hot loops and pipeline chains.

## Leak and lifetime checklist

- What owns this subscription, job, or callback?
- When is it cancelled or closed?
- Does a long-lived lambda capture a large object graph?
- Is cleanup explicit, or are we assuming the runtime will eventually clean it up for us?
- Does this cache or collection grow without a bound or eviction policy?
- Is a mutable object used as a hash key or set member?

## Allocation checklist

- Does this pipeline create intermediate collections on every call?
- Are we repeatedly creating ranges, wrappers, or temporary strings inside a hot loop?
- Are we copying data when a view, stream, or direct traversal would do?
- Are we using value equality where identity checks would be wrong or misleading?

## Strings

The `stringPool` examples are a warning, not a license to intern everything.

- Use `==` for string value equality.
- Do not build logic around `===` for externally produced strings.
- Do not introduce interning unless repeated duplicate strings are a measured memory problem and lifecycle is controlled.

## Mutable keys

If a key can change after insertion, hash-based collections become unstable. That is both a correctness problem and a performance problem because failed lookups and duplicate retention follow from broken identity semantics.

Default stance:

- use immutable data classes for keys
- mutate values, not keys
- if mutation is required, remove and reinsert explicitly

## When to specialize

Only trade readability for allocation reduction when one of these is true:

- the code is on a measured hot path
- allocation churn is driving GC cost
- the code runs frequently enough that tiny savings compound materially
