package ImportCsv::Data::Base;

use Mojo::Base qw/Mojolicious::Command/;
use Getopt::Long qw(GetOptionsFromArray :config no_auto_abbrev no_ignore_case);
use Mojo::Pg;
#use Mojo::Pg::Transaction;
use CGI::Session;
use Data::Dumper;
use constant DEBUG => 0;
#use constant AUTOCOMMIT => 0;
#use constant RAISEERROR => 1;

has commons_config => sub {
    my $config = ImportCsv::Commons::Config->new;
    $config->load_config();
};
has utils => sub{
     return ImportCsv::Commons::Utils->new;
};

sub get_conenction
{
    my ($self, @args) = @_;
#    my $session = CGI::Session->new(undef,undef,{Directory => '/tmp'});
#    if ( !$session->param('pg') ){
#        warn Dumper " not found Session: pg";
#        $session->expire('+30m');
#        warn Dumper  $session->param('pg');
    my $pg = undef;
    eval{
        $pg = Mojo::Pg->new('postgresql://'.$self->commons_config->{'database'}->{'user'}.'@'
            .$self->commons_config->{'database'}->{'host'}.'/'.$self->commons_config->{'database'}->{'dbname'});
        $pg->password($self->commons_config->{'database'}->{'password'});
#        $pg->options({AutoCommit => 1, RaiseError => 1});
    };
    if ($@){
        $self->utils->logger($@);
        exit 1;
    }
    return $pg;
}

1;

