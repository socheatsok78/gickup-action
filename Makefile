it:
build:
	docker buildx bake --load dev
run: build
	docker run --rm -it \
		-v "$(PWD)/fake/github:/github" \
		-v "$(PWD)/fake/tmp:/tmp" \
		--workdir /github/workspace \
		-e GOMPLATE_LOG_FORMAT=console \
		-e INPUT_DRYRUN=true \
		docker.io/library/gickup-action:dev
