import errno, requests
from os import makedirs
from os.path import expanduser, exists
from re import findall

web_address = "https://www.blackhat.com/us-17/briefings.html"

print "Starting downloading of files from {}".format(web_address)
r = requests.get(web_address)
download_list = findall('href=\"(\S*.pdf)\"', r.content)
print "Found {} files".format(len(download_list))

path = expanduser("~") + "/Documents/" + web_address.split(".")[1] + "/"
if not exists(path):
    try:
        makedirs(path)
    except OSError as exception:
        if exception.errno != errno.EEXIST:
            raise

for x in range(len(download_list)):
	print "Downloading file #{} from {}".format(x, download_list[x].split("/")[-1])
	pdf = requests.get(download_list[x])
	fd = open(path + download_list[x].split("/")[-1], "wb")
	fd.write(pdf.content)
	fd.close()
