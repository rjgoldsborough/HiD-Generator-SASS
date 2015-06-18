package HiD::Generator::SASS;

# ABSTRACT: transform SASS files to CSS 

=head1 DESCRIPTION

=cut

use Moose;
with 'HiD::Generator';
use File::Find::Rule;
use CSS::Sass;

use 5.014;

use HiD::VirtualPage;

=method generate

=cut

sub generate {
  my($self, $site) = @_;

  my $sass_source = $site->config->{sass_source};

  my $sass = CSS::Sass->new(
    include_paths => [$sass_source],
    output_style  => SASS_STYLE_COMPRESSED
  );

  my @sass_files = File::Find::Rule->file()
                                   ->name('*.scss')
                                   ->in($sass_source);

  foreach my $file (@sass_files) {
    my $css = $sass->compile_file($file);
    my $filename = $file;
    $filename =~ /\/([a-zA-Z0-9]+)\./;

    my $css_file = HiD::VirtualPage->new({
      content => $css,
      output_filename => $site->config->{sass_output} . $1 . '.css'
    });

    $site->add_object($css_file);
  }

  $site->INFO("* Transformed SASS files");
}


__PACKAGE__->meta->make_immutable;
1;
