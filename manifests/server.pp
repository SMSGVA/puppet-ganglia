# Class: ganglia::server
#
# This class installs the ganglia server
#
# Parameters:
#
#   $gridname
#     default  'unspecified'
#     the name for the grid of clusters
#
#   $clusters
#     default  [ 'my_cluster', ]
#     array of the names of the clusters to publish metrics of
#
#   $enable_service
#     default  'true'
#     Enable service at boot. Must be false if service is controlled by a resource manager, i.e. Pacemaker.
#
# Actions:
#   installs the ganglia server
#
# Sample Usage:
#   include ganglia::server
#
class ganglia::server (
  $clusters = [{cluster_name => 'my_cluster', cluster_hosts => [{address => 'localhost', port => '8649'}]}],
  $gridname = '',
  $enable_service = true,
  ) {

  $ganglia_server_pkg = 'gmetad'

  package {$ganglia_server_pkg:
    ensure => present,
    alias  => 'ganglia_server',
  }

  service {$ganglia_server_pkg:
    enable  => $enable_service,
    require => Package[$ganglia_server_pkg];
  }

  file {'/etc/ganglia/gmetad.conf':
    ensure  => present,
    require => Package['ganglia_server'],
    notify  => Service[$ganglia_server_pkg],
    content => template('ganglia/gmetad.conf');
  }

  if ($::osfamily == 'Debian') {
    file {'/etc/init.d/gmetad':
      ensure  => present,
      source  => 'puppet:///modules/ganglia/gmetad.init',
      require => Package['ganglia_server'],
      notify  => Service[$ganglia_server_pkg],
    }
  }

}
