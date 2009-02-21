#!/bin/bash

export PATH="$HOME/.gem/ruby/1.8/bin:/usr/java/jdk1.6.0_12/bin:/usr/local/bin:/bin:/usr/bin:$HOME/bin"

echo Using path: $PATH
rake setup
rake

