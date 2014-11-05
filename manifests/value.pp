# Manage sysctl value
#
# It not only manages the entry within
# /etc/sysctl.conf, but also checks the
# current active version.
#
# Parameters
#
# * value: to set.
# * key Key to set, default: $name
# * target: an alternative target for your sysctl values.
define sysctl::value (
  $value,
  $key    = $name,
  $target = undef,
) {
  require sysctl::base
  $val1 = inline_template("<%= @value.split(/[\s\t]/).reject(&:empty?).flatten.join(\"\t\") %>")

  $array = split($value,'[\s\t]')
  $val1 = inline_template("<%= @array.delete_if(&:empty?).flatten.join(\"\t\") %>")

  $real_key = $key ? {
    'name'  => $name,
    default => $key,
  }

  sysctl { $real_key :
    val    => $val1,
    before => Exec["exec_sysctl_${real_key}"],
  }

  $command = $::kernel ? {
    openbsd => "/sbin/sysctl ${real_key}=\"${val1}\"",
    default => "/sbin/sysctl -w ${real_key}=\"${val1}\"",
  }

  $unless = $::kernel ? {
    openbsd => "/sbin/sysctl ${real_key} | grep -q '=${val1}\$'",
    default => "/sbin/sysctl ${real_key} | grep -q ' = ${val1}'",
  }

  exec { "exec_sysctl_${real_key}" :
      command => $command,
      unless  => $unless,
      require => Sysctl[$real_key],
  }
}
