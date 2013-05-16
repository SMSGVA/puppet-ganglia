#
define ganglia::module (
    $path = "/usr/lib/ganglia/mod${name}",
    $order = 20,
    $deploy = true,
    $language = false,
    $params = false,
    $param = false,
) {
    if $deploy {
        file {
            $path:
                ensure  => present,
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                source  => "puppet:///modules/ganglia/modules/${name}";
        }
    }
    concat::fragment {
        "frag-ganglia-mod_${name}":
            order   => $order,
            target  => '/etc/ganglia/conf.d/modules.conf',
            content => template( 'ganglia/module.erb' );
    }
}
