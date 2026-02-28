# Neo4j Import Instructions

1. Start Neo4j Desktop
2. Create a new database
3. Use the Neo4j Import Tool:
   ```
   neo4j-admin import --nodes=/home/ldd_team/Linux_kernel_safety_tool/web_dashboard/data/linux-6.6.1_result/neo4j_data_linux-6.6.1/nodes.csv --relationships=/home/ldd_team/Linux_kernel_safety_tool/web_dashboard/data/linux-6.6.1_result/neo4j_data_linux-6.6.1/edges.csv
   ```
