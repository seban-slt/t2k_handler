CRC := ./crc32.py

xex:
	xasm handler.xsm -o handler.xex

chk:	xex
	chkxex handler.xex
	$(CRC) handler.xex

atr:	xex
	cp handler.xex handler.com
	mkatr -s 368640 handler.atr dos/ -b dos/XBW130.DOS dos/BOOT.COM dos/BLOAD.COM dos/COPY.COM dos/DUMP.COM dos/MEM.COM dos/OFFLOAD.COM handler.com
	rm -f handler.com

cpy:	atr
	cp handler.atr /media/sf_SF/handler

run:	atr
	wine c:/altirra/altirra64.exe handler.atr
