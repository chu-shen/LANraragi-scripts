package LANraragi::Plugin::Metadata::Rating;

use strict;
use warnings;

use LANraragi::Model::Plugins;
use LANraragi::Utils::Logging qw(get_plugin_logger);
use LANraragi::Utils::Database qw(set_tags);

#Meta-information about your plugin.
sub plugin_info {

    return (
        #Standard metadata
        name        => "Rating Score",
        type        => "metadata",
        namespace   => "rating",
        author      => "CHUSHEN",
        version     => "1.0",
        description => "Add Score To Tag. Right click to use. Do not use directly on the Plugin Configuration Page!",
        oneshot_arg  => "Rating Score"
    );

}

#Mandatory function to be implemented by your plugin
sub get_tags {
    shift;
    my $lrr_info = shift;     # Global info hash

    my $logger = get_plugin_logger();

    # Get the runtime parameter
    my $id = $lrr_info->{archive_id};
    my $rating_score = $lrr_info->{oneshot_param};

    my $tag = "Rating:$rating_score";
    #TODO replace old rating tag
    set_tags( $id, $tag, 1);

    $logger->info( "Sending the following tags to LRR: " . $tag );
    return ( error => "my error :(" );

}

1;