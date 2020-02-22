#!/usr/bin/env bash
# Script to run from release container to boot a node/ 
# This will run migration and start to node.

set -eux

/app/bin/docker_stake_service eval 'Elixir.DockerStakeService.ReleaseTasks.seed()'
/app/bin/docker_stake_service start