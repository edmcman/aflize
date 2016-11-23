covize
======

1. Run docker build -t covize .
2. For an ubuntu package pkg, build a docker image containing the coverage-instrumented binaries with ./setup-image.bash pkg
3. To gather coverage data, run ./run-command.bash pkg file_name_to_run pkg-cmd -x @@ and then scan the pkg dir for coverage data.
