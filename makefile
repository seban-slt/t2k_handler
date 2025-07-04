CRC := ./tools/crc32.py
XEDISK := ./tools/xedisk
ALTIRRA := /c/altirra/altirra64.exe

.PHONY: run-bwdos run-mydos run-image

xex:
	xasm handler.xsm -o handler.xex

chk:	xex
	chkxex handler.xex
	$(CRC) handler.xex

bwdos:	xex
	cp handler.xex handler.com
	mkatr -s 368640 t2k_handler_bwdos.atr dos/ -b dos/xbw14d.dos dos/dosdrive.com dos/pwd.com dos/copy.com dos/dump.com dos/mem.com dos/offload.com dos/ramdisk.com handler.com
	rm -f handler.com

mydos:	xex
	$(XEDISK) create -f mydos t2k_handler_mydos.atr
	$(XEDISK) write-dos -D mydos455 t2k_handler_mydos.atr
	$(XEDISK) add t2k_handler_mydos.atr handler.xex

cpy:	mydos bwdos
	cp *.atr /media/sf_SF/handler/

run-bw:	bwdos
	@$(MAKE) run-image IMAGE=t2k_handler_bwdos.atr

run-md:	mydos
	@$(MAKE) run-image IMAGE=t2k_handler_mydos.atr

run-image:
	@if [ -f "$(ALTIRRA)" ]; then \
		echo "Running with Altirra and image $(IMAGE)..."; \
		wine "$(ALTIRRA)" "$(IMAGE)"; \
	else \
		echo "Altirra not found, falling back to Atari800..."; \
		atari800 "$(IMAGE)"; \
	fi

run:	run-md
