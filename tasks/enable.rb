#!/opt/puppetlabs/puppet/bin/ruby
################################################################################
# Enables the Puppet agent on this node, permitting it to resume making changes
# to the local node.  This does not start the Puppet agent daemon; it merely
# reverses the lock imposed by the puppet_agent::disable task.
################################################################################
require 'json'
require 'open3'
require 'puppet'

def run
  cmd = ['puppet', '--enable']
  stdout, stderr, status = Open3.capture3(*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, _("stderr: ' %{stderr}') % { stderr: stderr }") if status != 0
  { status: stdout.strip }
end

begin
  puts run.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end

# vim: syntax=ruby:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
