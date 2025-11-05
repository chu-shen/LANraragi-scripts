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
        version     => "1.1",
        description => "Translate title by AI",
        parameters  => [
            { type => 'string', desc => 'OpenAI API Key' },
            { type => 'string', desc => 'Translation Prompt', default_value => 'Translate this title to English' },
            { type => 'string', desc => 'API URL (optional). Default: https://api.openai.com/v1/chat/completions', default_value => 'https://api.openai.com/v1/chat/completions' },
            { type => 'string', desc => 'Model (optional). Default: gpt-3.5-turbo', default_value => 'gpt-3.5-turbo' },
            { type => 'int', desc => 'Temperature (optional). Default: 1.3', default_value => 1.3 },
            { type => 'string', desc => 'Tag Name (optional). Default: TranslateTitleByAI', default_value => 'TranslateTitleByAI' }
        ]
    );
}

sub get_tags {
    shift;
    my $lrr_info = shift;
    my $logger = get_plugin_logger();

    my ($api_key, $prompt, $url, $model, $temperature, $tag_name) = @_;

    unless ($api_key) {
        $logger->error("API key is required");
        die "API key is required\n";
    }

    $prompt = 'Translate this title to English' if !defined $prompt || $prompt eq '';
    $url = 'https://api.openai.com/v1/chat/completions' if !defined $url || $url eq '';
    $model = 'gpt-3.5-turbo' if !defined $model || $model eq '';
    $temperature = 1.3 if !defined $temperature || $temperature eq '';
    $temperature = $temperature + 0;
    $tag_name = 'TranslateTitleByAI' if !defined $tag_name || $tag_name eq '';


    my $title = $lrr_info->{archive_title};
    my $tags = $lrr_info->{existing_tags};

    my $full_prompt = "$prompt: $title";

    my $ua = Mojo::UserAgent->new;

    my $translate = $ua->post(
            $url => {
                'Content-Type'  => 'application/json',
                'Authorization' => "Bearer $api_key",
                'Accept' => 'application/json'
            } => json => {
                model       => $model,
                messages    => [{ role => "user", content => $full_prompt}],
                temperature => $temperature,
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

    $tags .= ",$tag_name:$result" if $result;

    $logger->info("Translation result: $title → $result");
    return ( tags => $tags );
}

1;