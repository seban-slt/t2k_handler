CRC := ./tools/crc32.py
ALTIRRA_WINE := $(HOME)/.wine/drive_c/altirra/Altirra64.exe
XEDISK := $(shell command -v xedisk 2>/dev/null || echo ./tools/xedisk)


.PHONY: run-bwdos run-mydos run-image

all:	clean xex bwdos mydos

xex:
	xasm handler.xsm -o handler.xex

chk:	xex
	chkxex handler.xex
	$(CRC) handler.xex

bwdos:	xex
	cp handler.xex handler.com
	mkatr -s 368640 t2k_handler_bwdos.atr \
			dos/ -b dos/xbw14d.dos \
			dos/dosdrive.com \
			dos/pwd.com \
			dos/copy.com \
			dos/dump.com \
			dos/mem.com \
			dos/offload.com \
			dos/ramdisk.com \
			handler.com
	rm -f handler.com

mydos:	xex
	$(XEDISK) create -f mydos t2k_handler_mydos.atr
	$(XEDISK) write-dos -D mydos455 t2k_handler_mydos.atr
	$(XEDISK) add t2k_handler_mydos.atr handler.xex

cpy:	mydos bwdos
	cp *.atr /media/sf_SF/handler/
	cp *.xex /media/sf_SF/handler/

release: clean xex mydos bwdos
	mv handler.xex t2k_handler.xex
	7z -mx9 a t2k_handler_v.1.1.zip *.xex *.atr
	mv t2k_handler.xex handler.xex

clean:
	rm -f *.xex *.atr *.zip

run-bw:	bwdos
	@$(MAKE) run-image IMAGE=t2k_handler_bwdos.atr

run-md:	mydos
	@$(MAKE) run-image IMAGE=t2k_handler_mydos.atr

run-image:
	@if [ -f "$(ALTIRRA_WINE)" ]; then \
		echo "Running with Altirra and image $(IMAGE)..."; \
		wine "$(ALTIRRA_WINE)" "$(IMAGE)"; \
	else \
		echo "Altirra not found, falling back to Atari800..."; \
		atari800 "$(IMAGE)"; \
	fi

run:	run-md
