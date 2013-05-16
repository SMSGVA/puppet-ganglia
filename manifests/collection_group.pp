#
define ganglia::collection_group (
    $collect_every = 40,
    $collect_once = false,
    $time_threshold = 180,
) {
    include concat::setup
    include ganglia::client
    concat {
        "/etc/ganglia/conf.d/collection_group-${name}.conf":
            notify  => Service[ $ganglia::client::ganglia_client_service ];
    }
    concat::fragment {
        "ganglia-collection_group-${name}-header":
            target  => "/etc/ganglia/conf.d/collection_group-${name}.conf",
            order   => 10,
            content => template( 'ganglia/collection_group-header.erb' );
        "ganglia-collection_group-${name}-footer":
            target  => "/etc/ganglia/conf.d/collection_group-${name}.conf",
            order   => 99,
            content => '}';
    }
}
