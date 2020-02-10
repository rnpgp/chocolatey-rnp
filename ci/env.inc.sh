. ci/env-common.inc.sh
. ci/env-msys.inc.sh

: "${MAKE_PARALLEL:=$CORES}"
export MAKE_PARALLEL

: "${CTEST_PARALLEL:=$CORES}"
export CTEST_PARALLEL

: "${PARALLEL_TEST_PROCESSORS:=$CORES}"
export PARALLEL_TEST_PROCESSORS

