#!/bin/bash

export PATH="/home/rails/.gem/ruby/1.8/bin:/usr/java/jdk1.6.0_12/bin:/usr/kerberos/bin:/usr/local/bin:/bin:/usr/bin:/home/rails/bin"
echo Using path: $PATH
rake setup
rake

