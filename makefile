CRC := ./crc32.py

xex:
	xasm handler.xsm -o handler.xex

chk:	xex
	chkxex handler.xex
	$(CRC) handler.xex

atr:	xex
	cp handler.xex handler.com
	mkatr -s 368640 handler.atr dos/ -b dos/xbw14d.dos dos/dosdrive.com dos/pwd.com dos/copy.com dos/dump.com dos/mem.com dos/offload.com dos/ramdisk.com handler.com
	rm -f handler.com

cpy:	atr
	cp handler.atr /media/sf_SF/handler

run:	atr
	wine c:/altirra/altirra64.exe handler.atr
