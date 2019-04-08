#!/bin/bash
USE="-openmp -sanitize" crossdev -t avr -s4 --without-headers -P -v
