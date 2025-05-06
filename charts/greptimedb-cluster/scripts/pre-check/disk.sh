echo "\n================== Disk tests =================="
echo "\n================== Running full I/O test =================="
fio --filename=/data/fio-rw.data --direct=1 --ioengine=libaio --time_based --runtime=60 --group_reporting \
    --name=seq-read --rw=read --bs=4k --iodepth=64 --numjobs=1 --size=1G \
    --name=seq-write --rw=write --bs=4k --iodepth=64 --numjobs=1 --size=1G \
    --name=rand-iops --rw=randrw --bs=4k --iodepth=256 --numjobs=4 --size=1G

echo "\n================== Running mixed read/write test =================="
fio --name=fiotest --filename=/data/fio.data --size=1Gb --rw=readwrite --bs=64k --direct=1 --numjobs=8 \
    --ioengine=libaio --iodepth=16 --group_reporting --runtime=60 --startdelay=60
