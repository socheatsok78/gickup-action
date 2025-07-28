it:
build:
	docker buildx bake --load dev
run: build
	docker run --rm -it \
		-e INPUT_DRYRUN=true \
		-e INPUT_CONFIG=.github/gickup.yml \
		-e RUNNER_WORKSPACE=/mnt/fake/workspace \
		-e RUNNER_TEMP=/mnt/fake/tmp \
		-e GOMPLATE_LOG_FORMAT=console \
		-v "$(PWD)/fake:/mnt/fake" \
		docker.io/library/gickup-action:dev
