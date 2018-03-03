#!/opt/puppetlabs/puppet/bin/ruby
################################################################################
# Performs a Puppet manifest run on the present node, reporting back the exit
# code, STDOUT, and STDERR.
################################################################################
require 'json'
require 'open3'
require 'puppet'

def run(environment, debug, jobid, noop)
  cmd = ['puppet', '--test']
  cmd << "--environment=#{environment}" unless environment.nil?
  cmd << "--debug" unless debug.nil?
  cmd << "--job-id=#{jobid}" unless jobid.nil?
  cmd << "--noop" unless noop.nil?
  stdout, stderr, status = Open3.capture3(*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, _("stderr: ' %{stderr}') % { stderr: stderr }") if status != 0
  { status: stdout.strip }
end

params      = JSON.parse(STDIN.read)
environment = params['environment']
debug       = params['debug']
jobid       = params['jobid']
noop        = params['noop']

begin
  result = run(environment, debug, jobid, noop)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end

# vim: syntax=ruby:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
