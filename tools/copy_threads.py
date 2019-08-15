import shutil
from threading import Thread
from shutil import copyfile

for x in range(11, 22):
    print("Copy file " + str(x) + "...")
    Thread(target=shutil.copy, args=["/root/sample.dd", "/mnt/cloud/s3fs-test/sample" + str(x) + ".dd"]).start()
