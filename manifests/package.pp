# Manages the installed Puppet agent package.  Can be used to pin its version,
# upgrade, downgrade, and uninstall.
#
# @summary Manages the installed Puppet agent package.
#
# @example
#  ---
#  classes:
#    - puppet_agent
#
class puppet_agent::package {
  package { 'puppet':
    ensure => $puppet_agent::package_ensure,
    name   => $puppet_agent::package_name,
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
