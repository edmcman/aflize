covize
======

Example: For ubuntu package _pkg_ on the command `pkg-cmd -x @@`.

1. First build a docker image containing the coverage-instrumented binaries with `./setup-image.bash pkg`.  This can take a long time.
2. If you have an output directory you want to view coverage for, run `sudo ./run-dir.bash pkg -d /path/to/output pkg-cmd -x @@`.
