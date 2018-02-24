# Manages the already-installed OSS Puppet Agent and its resources.  While a
# Puppet agent cannot initially install itself, this module can be used to
# maintain that agent after it has been installed.  Package version, presence,
# and agent configuration are enabled.  In addition, a collection of useful
# facts about the installed agent are supplied.  Further, you can use the
# agent's various certificate files with other applications that are tolerant
# of self-signed certificates by also adding the bonus puppet_agent::copy_certs
# class.
#
# @summary Manages the already-installed OSS Puppet Agent and its resources.
#
# @example
#  ---
#  classes:
#    - puppet_agent
#
class puppet_agent {
  class { '::puppet_agent::package': }
  -> class { '::puppet_agent::config': }
  ~> class { '::puppet_agent::service': }
  -> Class['puppet_agent']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
