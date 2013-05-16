#
define ganglia::metric (
    $order = 20,
    $value_threshold = false,
    $title,
    $collection_group,
) {
    concat::fragment {
        "frag-ganglia-collection_group-${collection_group}-$name":
            target  => "/etc/ganglia/conf.d/collection_group-${collection_group}.conf",
            order   => $order,
            content => template( 'ganglia/metric.erb' );
    }
}
