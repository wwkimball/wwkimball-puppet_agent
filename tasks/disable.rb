#!/opt/puppetlabs/puppet/bin/ruby
################################################################################
# Disables the Puppet agent on this node, supplying an optional message that is
# presented whenever the Puppet agent later attempts to run while still
# disabled.  This does not stop the Puppet agent.  It does block the Puppet
# agent from making any further changes to the local node.
################################################################################
require 'json'
require 'open3'
require 'puppet'

def run(message)
  cmd = ['puppet']

  # Add an optional message, if provided
  if message.nil?
    cmd << '--disable'
  else
    safe_message = message.gsub('"', '\"')
    cmd << "--disable=\"#{safe_message}\""
  end

  stdout, stderr, status = Open3.capture3(*cmd) # rubocop:disable Lint/UselessAssignment
  raise Puppet::Error, _("stderr: ' %{stderr}') % { stderr: stderr }") if status != 0
  { status: stdout.strip }
end

params  = JSON.parse(STDIN.read)
message = params['message']

begin
  result = run(message)
  puts result.to_json
  exit 0
rescue Puppet::Error => e
  puts({ status: 'failure', error: e.message }.to_json)
  exit 1
end

# vim: syntax=ruby:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
