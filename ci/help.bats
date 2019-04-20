@test "help displays correctly" {
  run docker-compose run --rm downer --help
  [[ ${output} =~ Usage:\ shutdown ]]
}
