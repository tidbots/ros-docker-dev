#! /bin/bash
# Copyright (c) 2025 Hiroyuki Okada
# All rights reserved.
USER_NAME:=$(shell id -un)
GROUP_NAME:=$(shell id -gn)
UID:=$(shell id -u)
GID:=$(shell id -g) 

# If the first argument is ...
ifneq (,$(findstring tools_,$(firstword $(MAKECMDGOALS))))
	# use the rest as arguments
	RUN_ARGS := $(wordlist 2,$(words $(MAKECMDGOALS)),$(MAKECMDGOALS))
	# ...and turn them into do-nothing targets
	#$(eval $(RUN_ARGS):;@:)
endif

.PHONY: help

help: ## This help.
	@awk 'BEGIN {FS = ":.*?## "} /^[\.0-9a-zA-Z_-]+:.*?## / {printf "\033[36m%-42s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help

build: ## Build All 
	docker compose -f compose.build.yaml build
	@printf "\n\033[92mBuild Docker Image: all\033[0m\n"


build_cpu: ## Build Humble [CPU] Container
	docker compose  -f compose.build.yaml build humble
	@printf "\n\033[92mBuild Docker Image: tidbots/ros:humble\033[0m\n"

build_gpu: ## Build Humble [GPU] Container
	docker compose  -f compose.build.yaml build humble-gpu
	@printf "\n\033[92mBuild Docker Image: tidbots/cuda:12.9.1-cudnn-devel-humble\033[0m\n"

run_cpu:  ## Run Humble [CPU] Container
	docker compose up -d humble && docker compose exec -ti humble tmux
	@printf "\n\033[92mRun Humble CPU : tidbots/ros:humble-hsr\033[0m\n"

run_gpu:  ## Run Humble [GPU] Container
	docker compose up -d humble-gpu && docker compose exec -ti humble-gpu tmux
	@printf "\n\033[92mRun Humble GPU : tidbots/cuda:12.9.1-cudnn-devel-humble\033[0m\n"
