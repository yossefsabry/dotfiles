---
name: algorithm_a_star
description: Use this skill when designing an indoor navigation system that needs graph construction, A* pathfinding, door-aware transitions, wall avoidance, clearance control, and multi-floor routing. Trigger it when the user wants a navigation architecture or algorithm design, or asks for A* in buildings, rooms, corridors, doors, or floor transitions. Default output is JavaScript-style pseudocode and a clear step-by-step plan.
---

# Indoor Navigation System Skill

## Purpose
This skill defines the architecture and implementation strategy for building a high-performance indoor navigation system using A* pathfinding. It supports:

- Room-based navigation
- Door-constrained movement
- Wall intersection prevention
- Node clearance handling
- Multi-floor routing (stairs, elevators)
- Optimized graph construction

## Output format
Provide:

1) A short plan (3-6 bullets) describing the pipeline.
2) JavaScript-style pseudocode blocks for:
   - Graph construction (nodes + edges)
   - A* search (priority queue, heuristic, reconstruction)
   - Door-aware and multi-floor transitions
3) A brief notes section for configuration constants and edge cases.

Keep the pseudocode readable and consistent with JS syntax (objects, arrays, function signatures). Use placeholders for geometry helpers (e.g., `segmentIntersectsWalls`, `pointInPolygon`).

# 1. System Architecture
The system must be divided into three core layers:
1. Geometry Layer
2. Navigation Graph Layer
3. Pathfinding Layer


## 1.1 Geometry Layer

Responsibilities:

- Parse MVF / GeoJSON data
- Extract:
  - Walls (polygons or segments)
  - Rooms (walkable areas)
  - Doors (transition connectors)
  - Stairs / Elevators (vertical connectors)
- Identify floor IDs
- Compute bounding boxes and centroids

Output:
Structured floor geometry data.


## 1.2 Navigation Graph Layer

This layer builds a constrained graph.

### Node Types

- ROOM_NODE
- DOOR_NODE
- CORRIDOR_NODE
- STAIR_NODE
- ELEVATOR_NODE

Each node must contain:

- id
- x
- y
- floorId
- type
- roomId (if applicable)


### Node Generation Rules

1. Nodes must be placed only inside walkable polygons.
2. A node must respect minimum wall clearance:

```
if distance(node, nearestWall) < MIN_CLEARANCE
reject node
```

3. Node spacing must respect maximum edge length:
```

if distance(nodeA, nodeB) <= MAX_EDGE_LENGTH
candidate for connection

```


### Edge Creation Rules

An edge is valid only if:

1. Distance <= MAX_EDGE_LENGTH
2. Line segment does not intersect any wall
3. Floor IDs match (unless vertical connector)

Wall intersection check must use:

- Segment-segment intersection test
- Or polygon intersection check


### Door-Constrained Movement

Room nodes may connect only to:

- Nodes within the same room
- Door nodes belonging to that room

Door nodes may connect to:

- Corridor nodes
- Adjacent room nodes
- Other valid transition nodes

This guarantees:

Room → Door → Corridor → Door → Room

No wall crossing logic is required in A* if graph is constructed correctly.


## 1.3 Multi-Floor Support
Each floor must have its own graph partition.

Vertical connectors:

- Stairs
- Elevators

These create cross-floor edges:

```
edge = {
from: stair_floor_0,
to: stair_floor_1,
cost: vertical_cost
}
```

Vertical cost may be:

- Euclidean distance in 3D
- Weighted constant
- Accessibility-aware weight

# 2. A* Pathfinding Implementation
Requirements:

- Use priority queue (min-heap)
- Use adjacency list for graph
- Use Euclidean heuristic:

```
h(n) = sqrt((x1 - x2)^2 + (y1 - y2)^2)
```

If multi-floor:

```
h(n) = sqrt((x1-x2)^2 + (y1-y2)^2 + (floorDiff * floorHeight)^2)
```


## 2.1 Performance Constraints

- Graph must be precomputed
- No geometry checks during A* execution
- Cache frequent routes if applicable
- Avoid dense grid graphs unless necessary
- Prefer sparse room-based graphs


# 3. Width and Clearance Control

Define constants:

```

MIN_CLEARANCE = 0.5m
MAX_EDGE_LENGTH = 3m
VERTICAL_COST = 8

```

Clearance must ensure:

- No node overlaps wall
- No edge crosses wall
- No unrealistic narrow passage routing


# 4. Path Rendering Rules

When path spans multiple floors:

1. Split path by floorId
2. Show:
   - Exit indicator on current floor
   - Entry indicator on next floor
3. Render only active floor segment


# 5. Advanced Extensions (Optional)

- One-way doors
- Restricted areas
- Real-time dynamic obstacles
- Hierarchical pathfinding (HPA*)
- Area cost weighting
- Accessibility mode (avoid stairs)
