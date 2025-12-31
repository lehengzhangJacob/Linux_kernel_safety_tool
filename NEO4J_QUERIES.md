# Neo4j 可视化查询指令集 (Cypher Queries)

本文档记录了用于分析 Linux 内核调用关系和全局变量访问的常用 Neo4j 查询语句。

## 1. 基础查询

### 查看数据库概览

查看数据库中的节点和关系总数。

```cypher
MATCH (n) RETURN count(n) as Nodes, count((n)-[]->()) as Relationships
```

### 随机浏览调用关系

随机展示 50 条函数调用路径，用于检查数据是否导入成功。

```cypher
MATCH path = (f1:Function)-[:CALLS]->(f2:Function)
RETURN path
LIMIT 50
```

---

## 2. 全局变量分析 (核心功能)

### 场景 A：查看特定全局变量的完整调用链

查看所有最终**读取**或**写入**了指定全局变量（例如 `vc_class`）的函数调用路径（深度最多 5 层）。
这是分析竞态条件最直观的视图。

```cypher
// 将 'vc_class' 替换为你感兴趣的变量名
MATCH path = (start:Function)-[:CALLS*1..5]->(end:Function)-[:READS|WRITES]->(g:GlobalVariable {name: 'vc_class'})
RETURN path
LIMIT 50
```

### 场景 B：可视化“最热门”的全局变量

找出被读取或写入次数最多的前 10 个全局变量，并直接展示它们与调用函数的连接图。这些变量通常是系统的核心状态。

```cypher
// 1. 先聚合统计，找出前 10 名
MATCH (f:Function)-[:READS|WRITES]->(g:GlobalVariable)
WITH g, count(f) as AccessCount
ORDER BY AccessCount DESC
LIMIT 10

// 2. 再基于这 10 个变量，画出它们的调用边
MATCH path = (func:Function)-[:READS|WRITES]->(g)
RETURN path
LIMIT 100
```

### 场景 C：只看“写入”操作

写入操作通常比读取操作更危险。此查询只展示修改了变量的路径。

```cypher
MATCH path = (start:Function)-[:CALLS*1..5]->(end:Function)-[:WRITES]->(g:GlobalVariable {name: 'vc_class'})
RETURN path
LIMIT 50
```

---

## 3. 进阶查询

### 查找两个函数之间的最短路径

查看函数 A 是否间接调用了函数 B。
注意：Linux 内核系统调用通常有前缀（如 `__x64_sys_` 或 `ksys_`）。

```cypher
MATCH (start:Function {name: '__x64_sys_read'}), (end:Function {name: 'vfs_read'})
MATCH path = shortestPath((start)-[:CALLS*]->(end))
RETURN path
```

### 查找可能存在竞态的变量（简单启发式）

查找同时被多个不同函数写入的全局变量。

```cypher
MATCH (f:Function)-[:WRITES]->(g:GlobalVariable)
WITH g, count(DISTINCT f) as Writers
WHERE Writers > 1
RETURN g.name, Writers
ORDER BY Writers DESC
LIMIT 20
```
