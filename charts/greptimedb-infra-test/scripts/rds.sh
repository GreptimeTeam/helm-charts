echo "\n================== PostgreSQL Tests =================="

# Configure PostgreSQL connection parameters
RDS_HOST="${RDS_HOST}"
RDS_PORT="${RDS_PORT}"
RDS_DATABASE="${RDS_DATABASE}"
RDS_USERNAME="${RDS_USERNAME}"
RDS_PASSWORD="${RDS_PASSWORD}"

psql_cli() {
    PGPASSWORD="$RDS_PASSWORD" psql -h "$RDS_HOST" -p "$RDS_PORT" -U "$RDS_USERNAME" -d "$RDS_DATABASE" "$@"
}

echo "\n================== Running connection test =================="

# Test connection
if psql_cli -c "SELECT 1" > /dev/null 2>&1; then
    echo "✓ Connection successful"
else
    echo "✗ Connection failed"
    exit 1
fi

# Get PostgreSQL version
PG_VERSION=$(psql_cli -t -c "SHOW server_version" | xargs)
echo "PostgreSQL version: $PG_VERSION"

echo "\n================== Running latency test =================="

# Measure query latency
for i in 1 2 3 4 5; do
    START=$(date +%s%N)
    psql_cli -c "SELECT 1" > /dev/null 2>&1
    END=$(date +%s%N)
    DURATION=$(echo "scale=2; ($END - $START) / 1000000" | bc)
    echo "  Query $i: ${DURATION}ms"
done

echo "\n================== Running write performance test =================="

# Create test table
psql_cli -c "DROP TABLE IF EXISTS perf_test CASCADE"
psql_cli -c "CREATE TABLE perf_test (id SERIAL PRIMARY KEY, data TEXT, created_at TIMESTAMP DEFAULT NOW())"

# Test single row insert performance
echo "Testing single row INSERT performance (1000 rows)..."
START=$(date +%s%N)
for i in {1..1000}; do
    psql_cli -c "INSERT INTO perf_test (data) VALUES ('test_data_$i')" > /dev/null 2>&1
done
END=$(date +%s%N)
INSERT_TIME=$(echo "scale=2; ($END - $START) / 1000000" | bc)
echo "  Inserted 1000 rows in ${INSERT_TIME}ms"
echo "  Average: $(echo "scale=2; $INSERT_TIME / 1000" | bc)ms per insert"

# Test bulk insert performance
echo "Testing bulk INSERT performance (10000 rows)..."
START=$(date +%s%N)
psql_cli -c "INSERT INTO perf_test (data) SELECT 'bulk_' || generate_series(1, 10000)" > /dev/null 2>&1
END=$(date +%s%N)
BULK_TIME=$(echo "scale=2; ($END - $START) / 1000000" | bc)
echo "  Bulk inserted 10000 rows in ${BULK_TIME}ms"
echo "  Throughput: $(echo "scale=0; 10000 * 1000 / $BULK_TIME" | bc) rows/sec"

echo "\n================== Running read performance test =================="

# Test count query performance
START=$(date +%s%N)
ROW_COUNT=$(psql_cli -t -c "SELECT COUNT(*) FROM perf_test" | xargs)
END=$(date +%s%N)
SELECT_TIME=$(echo "scale=2; ($END - $START) / 1000000" | bc)
echo "  Total rows: $ROW_COUNT"
echo "  Count query took: ${SELECT_TIME}ms"

# Test conditional query performance
START=$(date +%s%N)
psql_cli -c "SELECT * FROM perf_test WHERE id < 1000" > /dev/null 2>&1
END=$(date +%s%N)
COND_TIME=$(echo "scale=2; ($END - $START) / 1000000" | bc)
echo "  SELECT with condition (id < 1000): ${COND_TIME}ms"

# Test aggregate query performance
START=$(date +%s%N)
psql_cli -c "SELECT data, COUNT(*) FROM perf_test GROUP BY data LIMIT 100" > /dev/null 2>&1
END=$(date +%s%N)
AGG_TIME=$(echo "scale=2; ($END - $START) / 1000000" | bc)
echo "  Aggregate query (GROUP BY): ${AGG_TIME}ms"

echo "\n================== Running concurrent connection test =================="

# Test concurrent connections
CONCURRENT_COUNT=20
for i in $(seq 1 $CONCURRENT_COUNT); do
    (psql_cli -c "SELECT pg_sleep(1)" > /dev/null 2>&1) &
done
wait
echo "  Spawned $CONCURRENT_COUNT concurrent connections (all completed)"

echo "\n================== Running database info query =================="

# Get database information
DB_SIZE=$(psql_cli -t -c "SELECT pg_database_size('$RDS_DATABASE')" | xargs)
ACTIVE_CONNS=$(psql_cli -t -c "SELECT COUNT(*) FROM pg_stat_activity" | xargs)
PG_UPTIME=$(psql_cli -t -c "SELECT pg_postmaster_start_time()" | xargs)

echo "  Database size: $DB_SIZE bytes"
echo "  Active connections: $ACTIVE_CONNS"
echo "  PostgreSQL uptime: $PG_UPTIME"

echo "\n================== Running cleanup =================="

# Clean up test table
psql_cli -c "DROP TABLE IF EXISTS perf_test"

echo "\n================== PostgreSQL tests completed =================="
