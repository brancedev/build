#!/bin/bash
# Created with package:mono_repo v4.0.0

# Support built in commands on windows out of the box.
# When it is a flutter repo (check the pubspec.yaml for "sdk: flutter")
# then "flutter" is called instead of "pub".
# This assumes that the Flutter SDK has been installed in a previous step.
function pub() {
  if grep -Fq "sdk: flutter" "${PWD}/pubspec.yaml"; then
    if [[ $TRAVIS_OS_NAME == "windows" ]]; then
      command flutter.bat pub "$@"
    else
      command flutter pub "$@"
    fi
  else
    if [[ $TRAVIS_OS_NAME == "windows" ]]; then
      command pub.bat "$@"
    else
      command pub "$@"
    fi
  fi
}
function dartfmt() {
  if [[ $TRAVIS_OS_NAME == "windows" ]]; then
    command dartfmt.bat "$@"
  else
    command dartfmt "$@"
  fi
}
function dartanalyzer() {
  if [[ $TRAVIS_OS_NAME == "windows" ]]; then
    command dartanalyzer.bat "$@"
  else
    command dartanalyzer "$@"
  fi
}

if [[ -z ${PKGS} ]]; then
  echo -e '\033[31mPKGS environment variable must be set! - TERMINATING JOB\033[0m'
  exit 64
fi

if [[ "$#" == "0" ]]; then
  echo -e '\033[31mAt least one task argument must be provided! - TERMINATING JOB\033[0m'
  exit 64
fi

SUCCESS_COUNT=0
declare -a FAILURES

for PKG in ${PKGS}; do
  echo -e "\033[1mPKG: ${PKG}\033[22m"
  EXIT_CODE=0
  pushd "${PKG}" >/dev/null || EXIT_CODE=$?

  if [[ ${EXIT_CODE} -ne 0 ]]; then
    echo -e "\033[31mPKG: '${PKG}' does not exist - TERMINATING JOB\033[0m"
    exit 64
  fi

  pub upgrade --no-precompile || EXIT_CODE=$?

  if [[ ${EXIT_CODE} -ne 0 ]]; then
    echo -e "\033[31mPKG: ${PKG}; 'pub upgrade' - FAILED  (${EXIT_CODE})\033[0m"
    FAILURES+=("${PKG}; 'pub upgrade'")
  else
    for TASK in "$@"; do
      EXIT_CODE=0
      echo
      echo -e "\033[1mPKG: ${PKG}; TASK: ${TASK}\033[22m"
      case ${TASK} in
      command_0)
        echo 'pub run build_runner test -- -p chrome --test-randomize-ordering-seed=random'
        pub run build_runner test -- -p chrome --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      command_1)
        echo 'pub run build_runner test -- -p vm test/configurable_uri_test.dart --test-randomize-ordering-seed=random'
        pub run build_runner test -- -p vm test/configurable_uri_test.dart --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      command_2)
        echo 'pub run build_runner test -- -p chrome,vm --test-randomize-ordering-seed=random'
        pub run build_runner test -- -p chrome,vm --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      command_3)
        echo 'pub run build_runner test --define="build_web_compilers:entrypoint=compiler=dart2js" -- -p chrome --test-randomize-ordering-seed=random'
        pub run build_runner test --define="build_web_compilers:entrypoint=compiler=dart2js" -- -p chrome --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      dartanalyzer)
        echo 'dartanalyzer --fatal-infos .'
        dartanalyzer --fatal-infos . || EXIT_CODE=$?
        ;;
      dartfmt)
        echo 'dartfmt -n --set-exit-if-changed .'
        dartfmt -n --set-exit-if-changed . || EXIT_CODE=$?
        ;;
      test_00)
        echo 'pub run test --total-shards 3 --shard-index 0 --test-randomize-ordering-seed=random'
        pub run test --total-shards 3 --shard-index 0 --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      test_01)
        echo 'pub run test --total-shards 3 --shard-index 1 --test-randomize-ordering-seed=random'
        pub run test --total-shards 3 --shard-index 1 --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      test_02)
        echo 'pub run test --total-shards 3 --shard-index 2 --test-randomize-ordering-seed=random'
        pub run test --total-shards 3 --shard-index 2 --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      test_03)
        echo 'pub run test'
        pub run test || EXIT_CODE=$?
        ;;
      test_04)
        echo 'pub run test --test-randomize-ordering-seed=random'
        pub run test --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      test_05)
        echo 'pub run test -P presubmit --test-randomize-ordering-seed=random'
        pub run test -P presubmit --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      test_06)
        echo 'pub run test -x integration --test-randomize-ordering-seed=random'
        pub run test -x integration --test-randomize-ordering-seed=random || EXIT_CODE=$?
        ;;
      test_07)
        echo 'pub run test -t integration --total-shards 5 --shard-index 0 --test-randomize-ordering-seed=random --no-chain-stack-traces'
        pub run test -t integration --total-shards 5 --shard-index 0 --test-randomize-ordering-seed=random --no-chain-stack-traces || EXIT_CODE=$?
        ;;
      test_08)
        echo 'pub run test -t integration --total-shards 5 --shard-index 1 --test-randomize-ordering-seed=random --no-chain-stack-traces'
        pub run test -t integration --total-shards 5 --shard-index 1 --test-randomize-ordering-seed=random --no-chain-stack-traces || EXIT_CODE=$?
        ;;
      test_09)
        echo 'pub run test -t integration --total-shards 5 --shard-index 2 --test-randomize-ordering-seed=random --no-chain-stack-traces'
        pub run test -t integration --total-shards 5 --shard-index 2 --test-randomize-ordering-seed=random --no-chain-stack-traces || EXIT_CODE=$?
        ;;
      test_10)
        echo 'pub run test -t integration --total-shards 5 --shard-index 3 --test-randomize-ordering-seed=random --no-chain-stack-traces'
        pub run test -t integration --total-shards 5 --shard-index 3 --test-randomize-ordering-seed=random --no-chain-stack-traces || EXIT_CODE=$?
        ;;
      test_11)
        echo 'pub run test -t integration --total-shards 5 --shard-index 4 --test-randomize-ordering-seed=random --no-chain-stack-traces'
        pub run test -t integration --total-shards 5 --shard-index 4 --test-randomize-ordering-seed=random --no-chain-stack-traces || EXIT_CODE=$?
        ;;
      *)
        echo -e "\033[31mUnknown TASK '${TASK}' - TERMINATING JOB\033[0m"
        exit 64
        ;;
      esac

      if [[ ${EXIT_CODE} -ne 0 ]]; then
        echo -e "\033[31mPKG: ${PKG}; TASK: ${TASK} - FAILED (${EXIT_CODE})\033[0m"
        FAILURES+=("${PKG}; TASK: ${TASK}")
      else
        echo -e "\033[32mPKG: ${PKG}; TASK: ${TASK} - SUCCEEDED\033[0m"
        SUCCESS_COUNT=$((SUCCESS_COUNT + 1))
      fi

    done
  fi

  echo
  echo -e "\033[32mSUCCESS COUNT: ${SUCCESS_COUNT}\033[0m"

  if [ ${#FAILURES[@]} -ne 0 ]; then
    echo -e "\033[31mFAILURES: ${#FAILURES[@]}\033[0m"
    for i in "${FAILURES[@]}"; do
      echo -e "\033[31m  $i\033[0m"
    done
  fi

  popd >/dev/null || exit 70
  echo
done

if [ ${#FAILURES[@]} -ne 0 ]; then
  exit 1
fi
