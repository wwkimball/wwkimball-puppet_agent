# A description of what this class does
#
# @summary A short summary of the purpose of this class
#
# @example
#
class puppet_agent::config {
  if 'purged' == $puppet_agent::package_ensure {
    # Note:  never destroy the $virtual_delivery_dir to avoid destroying mail.
    file { $puppet_agent::config_file_path:
      ensure => absent,
      force  => true,
    }
  } else {
    $knockout_prefix = $puppet_agent::config_hash_key_knockout_prefix

    # Ensure the configuration directory exists
    $purge_recurse_limit = $puppet_agent::purge_config_file_path ? {
      true    => 1,
      default => undef,
    }

    if $puppet_agent::config_managed {
	    file { $puppet_agent::config_file_path:
	      ensure       => directory,
	      purge        => $puppet_agent::purge_config_file_path,
	      recurse      => $puppet_agent::purge_config_file_path,
	      recurselimit => $purge_recurse_limit,
	      *            => $puppet_agent::config_file_path_attributes,
	    }

	    # Manage puppet.conf
	    file { "${puppet_agent::config_file_path}/puppet.conf":
	      ensure  => file,
	      content => template("${module_name}/config-file.erb"),
	      *       => $puppet_agent::config_file_attributes,;
	    }
    }
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
