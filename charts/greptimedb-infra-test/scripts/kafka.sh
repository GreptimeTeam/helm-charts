echo "\n================== Kafka test =================="

KAFKA_ENDPOINT=${KAFKA_ENDPOINT}
TOPIC="test-topic"
CONSUMER_TIMEOUT_MS=15000  # 15s

echo "\n================== Creating Kafka Topic =================="
if ! ./kafka/bin/kafka-topics.sh --create \
    --topic $TOPIC \
    --bootstrap-server $KAFKA_ENDPOINT \
    --partitions 3 \
    --replication-factor 1 \
    --if-not-exists; then
    echo "ERROR: Failed to create Kafka topic $TOPIC"
    exit 1
fi

echo "\n================== Starting Consumer =================="
./kafka/bin/kafka-console-consumer.sh \
    --bootstrap-server $KAFKA_ENDPOINT \
    --topic $TOPIC \
    --timeout-ms $CONSUMER_TIMEOUT_MS \
    > kafka_consume.log 2>&1 &

CONSUMER_PID=$!

sleep 5
if ! ps -p $CONSUMER_PID > /dev/null; then
    echo "ERROR: Kafka consumer failed to start"
    cat kafka_consume.log
    exit 1
fi

echo "\n================== Producing Messages =================="
start_time=$(date +%s)
if ! seq 1 20 | ./kafka/bin/kafka-console-producer.sh \
    --broker-list $KAFKA_ENDPOINT \
    --topic $TOPIC \
    --batch-size 10; then
    echo "ERROR: Failed to produce messages to Kafka"
    kill $CONSUMER_PID 2>/dev/null
    exit 1
fi
end_time=$(date +%s)
echo "Produce time: $((end_time - start_time)) seconds"

wait $CONSUMER_PID
CONSUMER_EXIT_CODE=$?

echo "\n================== Consumed Messages =================="
if [ $CONSUMER_EXIT_CODE -ne 0 ]; then
    echo "ERROR: Kafka consumer failed (exit code: $CONSUMER_EXIT_CODE)"
    cat kafka_consume.log
    exit 1
fi

MESSAGE_COUNT=$(cat kafka_consume.log | wc -l)
if [ "$MESSAGE_COUNT" -lt 20 ]; then
    echo "ERROR: Expected 20 messages, but only got $MESSAGE_COUNT"
    exit 1
else
    echo "Successfully consumed $MESSAGE_COUNT messages"
fi
