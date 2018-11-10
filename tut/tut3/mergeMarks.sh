#!/bin/bash


sort students | join marks - | sort -k4 | cut -d" " -f2,4-5

