this_container=$(shell docker ps --filter "name=${CONTAINERNAME}" -aq)
devcontainers=$(shell docker ps --filter "name=devcontainer" -aq | grep -v ${this_container})
IMGNAME = buildbase:latest
CMD := $(shell docker images -q ${IMGNAME} 2> /dev/null)


buildbase:
ifeq ($(CMD),)
	docker build -t buildbase -f .devcontainer/Build.Dockerfile_base /workspace/.devcontainer
endif

buildbaseserver:
	docker build -f /workspace/.devcontainer/Dockerfile-base --rm --no-cache -t centos7-sshd .
executable: buildbase
	cd /workspace/.devcontainer/ && \
	/workspace/.devcontainer/BuildMe.sh

container:
	@echo ${this_container}
rebuild:
	docker rm -f $(devcontainers) $(this_container)
removealldocker:
	docker rm -f $(devcontainers)
genversion:
	echo "version_dict = {\"git_hash\":\"\"\"">/workspace/scripts/version.py
	git rev-parse HEAD >>/workspace/scripts/version.py
	echo "\"\"\",">>/workspace/scripts/version.py
	echo "\"build_time\":\"\"\"">>/workspace/scripts/version.py
	date >>/workspace/scripts/version.py
	echo "\"\"\"">>/workspace/scripts/version.py
	echo "}">>/workspace/scripts/version.py