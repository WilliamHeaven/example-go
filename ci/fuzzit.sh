set -xe

## Install go-fuzz
go get -u github.com/dvyukov/go-fuzz/go-fuzz github.com/dvyukov/go-fuzz/go-fuzz-build

## build and send to fuzzit
go build ./...
go-fuzz-build -libfuzzer -o fuzzer.a ./...
clang -fsanitize=fuzzer fuzzer.a -o fuzzer

wget -q -O fuzzit https://github.com/fuzzitdev/fuzzit/releases/download/v1.2.7/fuzzit_Linux_x86_64
chmod a+x fuzzit
./fuzzit auth ${FUZZIT_API_KEY}
export TARGET_ID=2n6hO2dQzylLxX5GGhRG
./fuzzit create job --type $1 --branch $TRAVIS_BRANCH --revision $TRAVIS_COMMIT $TARGET_ID ./fuzzer
