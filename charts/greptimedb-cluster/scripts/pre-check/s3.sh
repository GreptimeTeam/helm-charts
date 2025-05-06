S3_BUCKET=${S3_BUCKET}

echo "\n================== Generating 10MB test file... =================="
dd if=/dev/urandom of=/tmp/s3-testfile bs=10M count=1 status=progress

echo "\n================== Running S3 transfer test... =================="
echo "\n================== Upload s3 testfile... =================="
start_time=$(date +%s)
script -q -c 's5cmd cp --show-progress /tmp/s3-testfile "s3://$S3_BUCKET/tmp/"' upload_testfile.log
cat upload_testfile.log
end_time=$(date +%s)
echo "\n================== Upload time: $((end_time - start_time)) seconds =================="

echo "\n================== Download s3 testfile... =================="
start_time=$(date +%s)
script -q -c 's5cmd cp --show-progress "s3://$S3_BUCKET/tmp/s3-testfile" /tmp/s3-testfile.download' download_testfile.log
cat download_testfile.log
end_time=$(date +%s)
echo "\n================== Download time: $((end_time - start_time)) seconds =================="

# Verify file integrity
echo "\n================== Verifying file integrity... =================="
original_size=$(wc -c < /tmp/s3-testfile)
downloaded_size=$(wc -c < /tmp/s3-testfile.download)
md5_original=$(md5sum /tmp/s3-testfile | awk '{print $1}')
md5_downloaded=$(md5sum /tmp/s3-testfile.download | awk '{print $1}')

if [ "$original_size" -eq "$downloaded_size" ] && [ "$md5_original" = "$md5_downloaded" ]; then
  echo "\n================== S3 test passed =================="
  echo "File size: $original_size bytes"
  echo "MD5 checksum: $md5_original"
else
  echo "\n================== S3 test failed =================="
  echo "Original size: $original_size bytes"
  echo "Downloaded size: $downloaded_size bytes"
  echo "Original MD5: $md5_original"
  echo "Downloaded MD5: $md5_downloaded"
  exit 1
fi
