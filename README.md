covize
======

Example: For ubuntu package _pkg_ on the command `pkg-cmd -x $SEEDFILE`.

1. First build a docker image containing the coverage-instrumented binaries with `./setup-image.bash pkg`.  This can take a long time.
2. If you have an AFL output dir and want to use afl-cov, simply run `sudo ./run-dir-through-afl-cov.bash pkg /path/to/afl/output pkg-cmd -x $SEEDFILE`.  The `sudo` is necessary because afl-cov will write into shared docker directories that are owned by a different user.
2b. If you have a coverage tool that allows you to specify a command to generate coverage, instruct it to use `run-command.bash pkg <FILENAME> pkg-cmd -x $SEEDFILE`, where `<FILENAME>` is the placeholder filename your coverage tool expects.  For example, in afl-cov this would be `AFL_FILE`.
