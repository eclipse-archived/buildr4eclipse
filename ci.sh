#!/bin/bash

export HOME="/home/rails"
export JAVA_HOME="/usr/java/jdk1.6.0_12"

export PATH="$HOME/.gem/ruby/1.8/bin:$JAVA_HOME/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:$HOME/bin"
echo Using path: $PATH

set

# rake setup
rake

