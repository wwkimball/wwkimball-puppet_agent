# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#
class puppet_agent::service {
  if $puppet_agent::service_managed
    and ! ($puppet_agent::package_ensure in ['absent', 'purged'])
  {
    service { 'puppet':
      ensure    => $puppet_agent::service_ensure,
      name      => $puppet_agent::service_name,
      enable    => $puppet_agent::service_enable,
      subscribe => [ Package['puppet'], ],
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
