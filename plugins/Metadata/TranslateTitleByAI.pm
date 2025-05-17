package LANraragi::Plugin::Metadata::TranslateTitleByAI;

use strict;
use warnings;
use utf8;

use Mojo::UserAgent;
use Mojo::JSON qw(true false);
use Encode qw(encode_utf8 decode_utf8); 
use LANraragi::Utils::Logging qw(get_plugin_logger);

sub plugin_info {
    return (
        name        => "Translate Title By AI",
        type        => "metadata",
        namespace   => "translatetitlebyai",
        author      => "CHUSHEN",
        version     => "1.0",
        description => "Translate title by AI",
        parameters  => [
            { type => 'string', desc => 'OpenAI API key' },
            { type => 'string', desc => 'Translation prompt', default_value => 'Translate this title to English:' },
            { type => 'string', desc => 'Custom API URL (optional)', default_value => 'https://api.openai.com/v1/chat/completions' },
            { type => 'string', desc => 'Custom model name (optional)', default_value => 'gpt-3.5-turbo' }
        ]
    );
}

sub get_tags {
    shift;
    my $lrr_info = shift;
    my $logger = get_plugin_logger();

    my ($api_key, $custom_prompt, $custom_url, $custom_model) = @_;

    my $title = $lrr_info->{archive_title};
    my $tags = $lrr_info->{existing_tags};

    my $prompt = "$custom_prompt: $title";

    my $ua = Mojo::UserAgent->new;

    my $translate = $ua->post(
            $custom_url => {
                'Content-Type'  => 'application/json',
                'Authorization' => "Bearer $api_key",
                'Accept' => 'application/json'
            } => json => {
                model       => $custom_model,
                messages    => [{ role => "user", content => $prompt ,temperature => 1.3}],
                stream      => false
            }
        );

    if (my $err = $translate->error) {
        my $error = "[$err->{code}] $err->{message}";
        $logger->error("API request failed: $error");
        die "API request failed: $error\n";
    }

    my $result = encode_utf8($translate->res->json->{choices}[0]{message}{content});

    $result =~ s/^[\s'"]+//;
    $result =~ s/[\s'"]+$//;
    $result =~ s/\s+/ /g;

    $result =decode_utf8($result);

    $tags .= ",TranslateTitleByAI:$result" if $result;

    $logger->info("Translation result: $title → $result");
    return ( tags => $tags );
}

1;