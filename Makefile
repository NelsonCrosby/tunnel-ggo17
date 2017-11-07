
default: run
clean:
	rm -rvf build dist

.PHONY: default clean

dist:
	@mkdir -pv dist
	zip dist/tunnel.love tunnel/*
.PHONY: dist

run:
	love tunnel
.PHONY: run
