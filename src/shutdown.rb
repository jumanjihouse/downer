#!/usr/bin/env ruby

require 'aws-sdk-ec2'
require 'memoist2'
require 'optparse'
require 'pp'
require 'yaml'

# Shut down all AWS instances in a region
# except for instances listed in a config file.
class Downer
  include Memoist2

  def initialize(path)
    # We assume you have set these environment variables:
    # ENV['AWS_REGION']
    # ENV['AWS_ACCESS_KEY_ID']
    # ENV['AWS_SECRET_ACCESS_KEY']
    @ec2 = Aws::EC2::Client.new

    @config_path = path
  end

  # Instance IDs of every instance in the region.
  #
  # @return [Array<String>] Instance IDs
  #
  # :reek:UncommunicativeVariableName { accept: r }
  memoize def all_instances
    reservations = @ec2.describe_instances.reservations
    reservations.flat_map { |r| r.instances.map(&:instance_id) }
  end

  # Instance IDs that should never be turned off.
  #
  # @return [Array<String>] Instance IDs
  #
  memoize def pilot_lights
    config = YAML.load_file(@config_path)
    config['pilot_lights']
  end

  # Instance IDs that should be shut down.
  #
  # @return [Array<String>] Instance IDs
  #
  memoize def to_shutdown
    # Pilot lights stay up 24x7; do not shut them down.
    all_instances - pilot_lights
  end

  # Shut down the correct instances.
  #
  # @return [Types::StopInstancesResult] on success
  # @return [String] on failure
  #
  # rubocop:disable Metrics/MethodLength
  # :reek:UncommunicativeVariableName { accept: e }
  def stop(dry_run = false)
    if dry_run || ENV['DEBUG']
      STDERR.puts format(
        '%<count>i instances to shut down.',
        count: to_shutdown.count,
      )
    end
    @ec2.stop_instances(
      dry_run: dry_run,
      force: false,
      instance_ids: to_shutdown,
    )
  rescue Aws::EC2::Errors::DryRunOperation => e
    e.message
  end
  # rubocop:enable Metrics/MethodLength
end

options = {}
options[:config] = '/pilot.yaml'
options[:dry_run] = false

optparse = OptionParser.new do |opts|
  opts.on('-c', '--config PATH', 'config file in YAML format') do |f|
    options[:config] = f
  end

  opts.on('-n', '--noop', 'perform a dry run') do
    options[:dry_run] = true
  end

  opts.on('-h', '--help', 'Display this screen') do
    puts opts
    exit
  end
end

optparse.parse!

begin
  response = Downer.new(options[:config]).stop(options[:dry_run])
  if response.is_a?(String)
    puts response
  else
    pp response
  end
rescue StandardError => e
  STDERR.puts format('%<class>s: %<msg>s', class: e.class, msg: e.message)
  STDERR.puts e.backtrace if ENV['DEBUG']
  exit(1)
end
