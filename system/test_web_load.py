import time
import telnetlib

# the address targeted
URL=""
# the range of port to target
PORTMIN=20001
PORTMAX=20100
# number of connections
TRIES=2000
# simultanous
#NBR_SIMUL=2000

for i in xrange(PORTMIN, PORTMAX+1):
    try:
        for j in xrange(1, TRIES):
            print i, j, URL
            tn=telnetlib.Telnet(URL,i, timeout=1)
            tn.write("\r\n")
            tn.close()
    
    except:
        print 'Error port:', i
        continue