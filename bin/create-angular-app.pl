use lib 'lib';
use List-Component;
use Detail-Component;
use Service;

sub file-name( $name ) {
	return './src/app/' ~ $name ~ '.ts';
}

sub MAIN {
	my $list-component = List-Component.new;
	my $detail-component = Detail-Component.new;
	my $service = Service.new;

	my $fh;

	$fh = open :w, file-name( 'heroes/hero-list.component' );
	$fh.say( $list-component.hero-list-component() );
	$fh.close;

	$fh = open :w, file-name( 'crisis-center/crisis-list.component' );
	$fh.say( $list-component.crisis-list-component() );
	$fh.close;

	$fh = open :w, file-name( 'heroes/hero-detail.component' );
	$fh.say( $detail-component.hero-detail-component() );
	$fh.close;

	$fh = open :w, file-name( 'crisis-center/crisis-detail.component' );
	$fh.say( $detail-component.crisis-detail-component() );
	$fh.close;

	$fh = open :w, file-name( 'heroes/hero.service' );
	$fh.say( $service.hero-service() );
	$fh.close;

	$fh = open :w, file-name( 'crisis-center/crisis.service' );
	$fh.say( $service.crisis-service() );
	$fh.close;
}
