# Enables you to make copies of the Puppet agent's various certificate files
# for use with other applications that are tolerant of self-signed certificates.
#
# @example
#  ---
#  classes:
#    - puppet_agent::cert_copies
#
class puppet_agent::cert_copies(
  Boolean              $manage_pki_base_dir,
  Stdlib::Absolutepath $pki_base_dir,
  Hash[String, Any]    $pki_base_dir_attrs,
  Optional[Hash[
    String[1],
    Struct[{
      group             => Variant[String[1], Integer],
      owner             => Variant[String[1], Integer],
      Optional['attrs'] => Hash[String[1], Any],
  }]]]                 $copy_to             = undef,
) {
  # Optionally manage the base PKI directory
  if $manage_pki_base_dir {
    file { $pki_base_dir:
      ensure => directory,
      *      => $pki_base_dir_attrs,
    }
  }

  # Instantiate the collection of requested certificate copies
  pick($copy_to, {}).each | String $name, Hash $props | {
    puppet_agent::defines::cert_copy { $name:
      owner   => $props['owner'],
      group   => $props['group'],
      attrs   => $props['attrs'],
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
