role Angular-Component {
	method to-component( Str $str ) {
		return qq:to[_END_];
\@Component(\{
$str
\})
_END_
	}

	method to-template( Str $str ) {
		return qq:to[_END_];
  template: `
$str
  `
_END_
	}

	method to-class( Str $name, Str $str ) {
		return qq:to[_END_];
export class $name implements OnInit \{
$str
\}
_END_
	}

	method common-import {
		return qq:to[_END_];
import 'rxjs/add/operator/switchMap';
import \{ Observable \}                     from 'rxjs/Observable';
import \{ Component, OnInit \}              from '\@angular/core';
import \{ ActivatedRoute, Router, Params \} from '\@angular/router';
_END_
	}
}

class List-Component {
	also does Angular-Component;

	method import-service( Str $table-name ) {
		my $import = qq:to[_END_];
import \{ {tc( $table-name )}, {tc( $table-name )}Service \} from './{$table-name}.service';
_END_
	}

	method template-list( Str $item, Str $collection ) {
		return qq:to[_END_];
    <ul class="items">
      <li *ngFor="let {$item} of {$collection} | async"
        [class.selected]="isSelected({$item})"
        (click)="onSelect({$item})">
        <span class="badge">\{\{ {$item}.id \}\}</span>
        \{\{ {$item}.name \}\}
      </li>
    </ul>
_END_
	}

	method crisis-list-component {
		my $table-name     = 'crisis';
		my $common-import  = self.common-import;
		my $import         = self.import-service( $table-name );
		my $type-name      = tc( $table-name );
		my $component-name = "{$type-name}ListComponent";
		my $item           = 'crisis';
		my $collection     = 'crises';
		my $list-html      = self.template-list( $item, $collection );
		my $component =
			self.to-component( self.to-template( qq:to[_END_] ) );
    <h2>{tc( $table-name )} List</h2>
$list-html

    <router-outlet></router-outlet>
_END_

		my $class =
			self.to-class( $component-name, qq:to[_END_] );
  {$collection}: Observable\<{$type-name}[]\>;

  private selectedId: number;

  ngOnInit() \{
    this.{$collection} = this.route.params
      .switchMap((params: Params) => \{
        this.selectedId = +params['id'];
        return this.service.getCrises();
      \});
  \}

  constructor(
    private service: CrisisService,
    private route:   ActivatedRoute,
    private router:  Router
  ) \{\}

  isSelected({$item}: {$type-name}) \{
    return {$item}.id === this.selectedId;
  \}

  onSelect({$item}: {$type-name}) \{
    this.selectedId = {$item}.id;

    // Navigate with relative link
    this.router.navigate([{$item}.id], \{ relativeTo: this.route \});
  \}
_END_

		return qq:to[_END_];
$common-import
$import
$component
$class
_END_
	}

	method hero-list-component {
		my $table-name     = 'hero';
		my $common-import  = self.common-import;
		my $import         = self.import-service( $table-name );
		my $type-name      = tc( $table-name );
		my $component-name = "{$type-name}ListComponent";
		my $item           = 'hero';
		my $collection     = 'heroes';
		my $list-html      = self.template-list( $item, $collection ); 
		my $component =
			self.to-component( self.to-template( qq:to[_END_] ));
    <h2>{tc( $table-name )} List</h2>
$list-html

    <button routerLink="/sidekicks">Go to sidekicks</button>
_END_

		my $class = self.to-class( $component-name, qq:to[_END_] );
  {$collection}: Observable\<{$type-name}[]\>;

  private selectedId: number;

  ngOnInit() \{
    this.{$collection} = this.route.params
      .switchMap((params: Params) => \{
        this.selectedId = +params['id'];
        return this.service.getHeroes();
      \});
  \}

  constructor(
    private service: HeroService,
    private route:   ActivatedRoute,
    private router:  Router
  ) \{\}

  isSelected({$item}: {$type-name}) \{
    return {$item}.id === this.selectedId;
  \}

  onSelect({$item}: {$type-name}) \{
    this.router.navigate(['/hero', {$item}.id]);
  \}
_END_

		return qq:to[_END_];
$common-import
$import
$component
$class
_END_
	}

	method file-name( $name ) {
		return './src/app/' ~ $name ~ '.ts';
	}

	method generate-files {
		my $path = './src/app/';
		my $fh;

		$fh = open :w,
			self.file-name( 'heroes/hero-list.component' );
		$fh.say( self.hero-list-component() );
		$fh.close;

		$fh = open :w,
			self.file-name( 'crisis-center/crisis-list.component' );
		$fh.say( self.crisis-list-component() );
		$fh.close;
	}
}

sub MAIN {
	my $list-component = List-Component.new;
	$list-component.generate-files;
}
