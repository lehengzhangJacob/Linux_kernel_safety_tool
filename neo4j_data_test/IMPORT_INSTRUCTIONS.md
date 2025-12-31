# How to Import into Neo4j

## Option 1: Neo4j Desktop (Local)
1. Create a new Project and Database.
2. Open the project folder (click '...' -> 'Open folder' -> 'Import').
3. Copy `nodes.csv` and `edges.csv` to the `import` folder.
4. Open Neo4j Browser and run the following Cypher commands (Note: LOAD CSV requires enabling file import in settings if not in import dir, but putting in import dir is easiest):

```cypher
// Create Constraints (Optional but recommended)
CREATE CONSTRAINT FOR (f:Function) REQUIRE f.id IS UNIQUE;
CREATE CONSTRAINT FOR (v:GlobalVariable) REQUIRE v.id IS UNIQUE;

// Load Nodes
LOAD CSV WITH HEADERS FROM 'file:///nodes.csv' AS row
CALL apoc.create.node([row[':LABEL']], {id: row['id:ID'], name: row['name']}) YIELD node RETURN count(*);

// Load Relationships
LOAD CSV WITH HEADERS FROM 'file:///edges.csv' AS row
MATCH (source {id: row[':START_ID']})
MATCH (target {id: row[':END_ID']})
CALL apoc.create.relationship(source, row[':TYPE'], {}, target) YIELD rel RETURN count(*);
```

*Note: The above Cypher uses APOC. If you don't have APOC, you'll need standard Cypher `MERGE` statements which are slower for large data.*

## Option 2: neo4j-admin import (Fastest, for fresh DB)
If you have access to the terminal of the Neo4j server:
```bash
neo4j-admin database import full --nodes=import/nodes.csv --relationships=import/edges.csv --overwrite-destination neo4j
```
