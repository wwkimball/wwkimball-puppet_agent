# Custom type supporting application-agnostic copies of the Puppet agent
# certificate files.
#
# Each supplied application entry attempts to supply these files:
#   - "${pki_base_dir}/${title}/ca.pem"
#   - "${pki_base_dir}/${title}/hostcert.pem"
#   - "${pki_base_dir}/${title}/hostprivkey.pem"
#   - "${pki_base_dir}/${title}/hostpubkey.pem"
#
define puppet_agent::defines::cert_copy(
  String[1]            $group,
  String[1]            $owner,
  Optional[Hash[
    String[1],
    Any
  ]]                   $attrs = {},
) {
  $pki_dir       = "${puppet_agent::cert_copies::pki_base_dir}/${title}"
  $agent_facts   = $facts['puppet_agent']
  $ca_cert       = $agent_facts['localcacert']
  $host_cert     = $agent_facts['hostcert']
  $host_priv_key = $agent_facts['hostprivkey']
  $host_pub_key  = $agent_facts['hostpubkey']

  # Maintain a clean PKI directory with application-specific permissions
  file { $pki_dir:
    ensure       => directory,
    owner        => $owner,
    group        => $group,
    mode         => '0550',
    recurse      => true,
    purge        => true,
    force        => true,
    recurselimit => 1,
    require      => File[$puppet_agent::cert_copies::pki_base_dir],
  }

  $pki_ca       = "${pki_dir}/ca.pem"
  $pki_cert     = "${pki_dir}/hostcert.pem"
  $pki_priv_key = "${pki_dir}/hostprivkey.pem"
  $pki_pub_key  = "${pki_dir}/hostpubkey.pem"

  file {
    default:
      ensure  => file,
      owner   => $owner,
      group   => $group,
      mode    => '0644',
      require => [
        File[$pki_dir],
      ],
      *       => $attrs,
    ;

    $pki_ca:
      source => $ca_cert,
    ;

    $pki_cert:
      source => $host_cert,
    ;

    $pki_priv_key:
      mode   => '0640',
      source => $host_priv_key,
    ;

    $pki_pub_key:
      mode   => '0640',
      source => $host_pub_key,
    ;
  }
}
# vim: syntax=puppet:tabstop=2:softtabstop=2:shiftwidth=2:expandtab:ai
