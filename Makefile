.PHONY: all
all: out/vco.v out/sine.v

.PHONY: docker
docker:
	make -C docker

out/%.v: models/%.py docker
	mkdir -p out
	docker run -e MODEL_NAME=$* -i msdsl-optimizer < $< > $@

.PHONY: clean
clean:
	rm -rf out
	make -C docker clean
