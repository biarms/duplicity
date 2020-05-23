# Brothers in ARMs' duplicity

![GitHub release (latest by date)](https://img.shields.io/github/v/release/biarms/duplicity?label=Latest%20Github%20release&logo=Github)
![GitHub release (latest SemVer including pre-releases)](https://img.shields.io/github/v/release/biarms/duplicity?include_prereleases&label=Highest%20GitHub%20release&logo=Github&sort=semver)

[![TravisCI build status image](https://img.shields.io/travis/biarms/duplicity/master?label=Travis%20build&logo=Travis)](https://travis-ci.org/biarms/duplicity)
[![CircleCI build status image](https://img.shields.io/circleci/build/gh/biarms/duplicity/master?label=CircleCI%20build&logo=CircleCI)](https://circleci.com/gh/biarms/duplicity)

[![Docker Pulls image](https://img.shields.io/docker/pulls/biarms/duplicity?logo=Docker)](https://hub.docker.com/r/biarms/duplicity)
[![Docker Stars image](https://img.shields.io/docker/stars/biarms/duplicity?logo=Docker)](https://hub.docker.com/r/biarms/duplicity)
[![Highest Docker release](https://img.shields.io/docker/v/biarms/duplicity?label=docker%20release&logo=Docker&sort=semver)](https://hub.docker.com/r/biarms/duplicity)

<!--
[![Travis build status](https://api.travis-ci.org/biarms/duplicity.svg?branch=master)](https://travis-ci.org/biarms/duplicity) 
[![CircleCI build status](https://circleci.com/gh/biarms/duplicity.svg?style=svg)](https://circleci.com/gh/biarms/duplicity)
-->

## Overview
This project build a very simple container based on python3-alpine which include the [duplicity](http://duplicity.nongnu.org/) backup utility.

Resulting docker images are pushed on [docker hub](https://hub.docker.com/r/biarms/duplicity/).

## How to build locally
1. Option 1: with CircleCI Local CLI:
   - Install [CircleCI Local CLI](https://circleci.com/docs/2.0/local-cli/)
   - Call `circleci local execute`
2. Option 2: with make:
   - Install [GNU make](https://www.gnu.org/software/make/manual/make.html). Version 3.81 (which came out-of-the-box on MacOS) should be OK.
   - Call `make build`
