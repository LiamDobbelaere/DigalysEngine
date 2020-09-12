import unittest

suite "sdescription for this stuff":
  echo "suite setup: run once before the tests"

  setup:
    echo "run before each test"

  teardown:
    echo "run after each test"

  test "essential truths":
    # give up and stop if this fails
    require(true)
