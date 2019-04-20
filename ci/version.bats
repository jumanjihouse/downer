@test "aws-sdk-ec2 is the expected version" {
  run docker-compose run --rm --entrypoint gem downer list '^aws-sdk-ec2$'
  [[ ${output} =~ \(${VERSION}\) ]]
}
