# Class: ganglia::webserver
#
# This class installs the ganglia web server
#
# Parameters:
#
# Actions:
#   installs the ganglia web server
#
# Sample Usage:
#   include ganglia::server
#
class ganglia::webserver(
    $apache_hostname = 'ganglia',
    $template_name = 'default',
    $gmetad_root = '/var/lib/ganglia',
    $rrds = '$gmetad_root/rrds',
    $rrdtool = '/usr/bin/rrdtool',
    $rrdcached_socket = '',
    $graphdir = './graph.d',
    $ganglia_ip = '127.0.0.1',
    $ganglia_port = '8652',
    $max_graphs = 0,
    $hostcols = 3,
    $metriccols = 2,
    $show_meta_snapshot = true,
    $default_refresh = 300,
    $cpu_user_color = '3333bb',
    $cpu_nice_color = 'ffea00',
    $cpu_system_color = 'dd0000',
    $cpu_wio_color = 'ff8a60',
    $cpu_idle_color = 'e2e2f2',
    $mem_used_color = '5555cc',
    $mem_shared_color = '0000aa',
    $mem_cached_color = '33cc33',
    $mem_buffered_color = '99ff33',
    $mem_free_color = '00ff00',
    $mem_swapped_color = '9900CC',
    $load_one_color = 'CCCCCC',
    $proc_run_color = '0000FF',
    $cpu_num_color  = 'FF0000',
    $num_nodes_color = '00FF00',
    $jobstart_color = 'ff3300',
    $load_colors = {
        '100+'      => 'ff634f',
        '75-100'    => 'ffa15e',
        '50-75'     => 'ffde5e',
        '25-50'     => 'caff98',
        '0-25'      => 'e2ecff',
        'down'      => '515151'
    },
    $load_scale = '1.0',
    $default_metric_color = '555555',
    $default_metric = 'load_one',
    $strip_domainname = false,
    $time_ranges = {
        'hour'      => 3600,
        'day'       => 86400,
        'week'      => 604800,
        'month'     => 2419200,
        'year'      => 31449600
    },
    $default_time_range = 'hour',
    $graph_sizes = {
        'small'     => {
            'height'    => 40,
            'width'     => 130,
            'fudge_0'   => 0,
            'fudge_1'   => 0,
            'fudge_2'   => 0
        },
        'medium'    => {
            'height'    => 75,
            'width'     => 300,
            'fudge_0'   => 0,
            'fudge_1'   => 14,
            'fudge_2'   => 28
        },
        'large'     => {
            'height'    => 600,
            'width'     => 800,
            'fudge_0'   => 0,
            'fudge_1'   => 0,
            'fudge_2'   => 0
        },
        'default'   => {
            'height'    => 100,
            'width'     => 400,
            'fudge_0'   => 0,
            'fudge_1'   => 0,
            'fudge_2'   => 0
        }
    },
    $default_graph_size = 'medium',
    $case_sensitive_hostnames = true,
) {

  $ganglia_webserver_pkg = $::osfamily ? {
    Debian => 'ganglia-webfrontend',
    RedHat => 'ganglia-web',
    default => fail("Module ${module_name} is not supported on
${::operatingsystem}")
  }

  package {$ganglia_webserver_pkg:
    ensure => present,
    alias  => 'ganglia_webserver',
  }

  apache::vhost { "ganglia.${::domain}":
    servername      => "ganglia.${::domain}",
    docroot         => '/usr/share/ganglia-webfrontend',
    serveradmin     => "ganglia@${::domain}",
    options         => [ 'FollowSymLinks' ],
    override        => [ 'All' ],
    custom_fragment => '  Alias /ganglia /usr/share/ganglia-webfrontend',
  }

  file {'/usr/share/ganglia-webfrontend/conf.php':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['ganglia_webserver'],
    content => template('ganglia/conf.php.erb');
  }
}
