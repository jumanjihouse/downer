@test "aws-sdk is the expected version" {
  run docker-compose run --rm --entrypoint gem downer list '^aws-sdk$'
  [[ ${output} =~ \(${VERSION}\) ]]
}
