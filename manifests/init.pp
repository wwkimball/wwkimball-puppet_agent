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
class puppet_agent(
  Hash[String[4], Any]           $config_file_attributes,
  String[3]                      $config_file_path,
  Hash[String[4], Any]           $config_file_path_attributes,
  Pattern[/^-+$/]                $config_hash_key_knockout_prefix,
  Boolean                        $config_managed,
  String                         $package_ensure,
  String[2]                      $package_name,
  Boolean                        $purge_config_file_path,
  Boolean                        $service_enable,
  Enum['running', 'stopped']     $service_ensure,
  Boolean                        $service_managed,
  String[2]                      $service_name,
  Optional[Hash[
    String[2],
    Any
  ]]                             $config                    = undef,
) {
  class { '::puppet_agent::package': }
  -> class { '::puppet_agent::config': }
  ~> class { '::puppet_agent::service': }
  -> Class['puppet_agent']
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
