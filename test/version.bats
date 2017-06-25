@test "aws-sdk is the expected version" {
  run docker run --rm -it --entrypoint gem jumanjiman/downer list '^aws-sdk$'
  [[ ${output} =~ \(${VERSION}\) ]]
}
