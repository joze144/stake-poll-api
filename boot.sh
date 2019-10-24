#!/usr/bin/env bash
# Script to run from release container to boot a node/ 
# This will run migration and start to node.

set -eux

./prod/rel/docker_stake_service/bin/docker_stake_service eval 'Elixir.DockerStakeService.ReleaseTasks.seed()'
./prod/rel/docker_stake_service/bin/docker_stake_service start