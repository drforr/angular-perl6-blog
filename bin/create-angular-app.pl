role Angular {
	method _import-str( Str $module, $package-ref ) {
		my $description = qq{'$module'};
		if $package-ref {
			my $package-str = @($package-ref).join(', ');
			$description = qq{\{ $package-str \} from '$module'};
		}
		return qq:to[_END_];
import $description;
_END_
	}

	method imports-toString( %import ) {
		my $imports = '';
		for %import.kv -> $k, $v {
			$imports ~= self._import-str( $k, $v );
		}
		return $imports;
	}

	method component-toString( %import ) {
		my $component = '';
		for %import.kv -> $k, $v {
			if $k eq 'template' {
				$component ~= qq:to[_END_];
  template: \`
$v
\`,
_END_
			}
			else {
				$component ~= "$k: $v,";
			}
		}
		return qq:to[_END_];
\@Component(\{
$component
\})
_END_
	}

	method injectable-toString( ) {
		return qq:to[_END_];
\@Injectable()
_END_
	}

	method ngModule-toString( %import ) {
		my $ngModule = '';
		for %import.kv -> $k, $v {
			my $v-string = @( $v ).join(', ');
			$ngModule ~= "$k: [ $v-string ],";
		}
		return qq:to[_END_];
\@NgModule(\{
$ngModule
\})
_END_
	}

	method export-class-toString(
		$name, $content, $methods, $implements = Any ) {
		my $description = $name;
		if $implements {
			$description = qq{$name implements $implements};
		}
		return qq:to[_END_];
export class $description \{
$content
$methods
\}
_END_
	}
}

class Sample-Hero {
	also does Angular;

	method hero-detail-component {
		my %import =
			'rxjs/add/operator/switchMap' => Any,
			'@angular/core'   => [< Component OnInit HostBinding >],
			'@angular/router' => [< Router ActivatedRoute Params >],
			'../animations'   => [< slideInDownAnimation >],
			'./hero.service'  => [< Hero HeroService >],
		;

		my $imports = self.imports-toString( %import );

		#animations => '[ slideInDownAnimation ]',
		my %component =
			template => q:to[_END_],
  <h2>HEROES</h2>
  <div *ngIf="hero">
    <h3>"\{\{ hero.name \}\}"</h3>
    <div>
      <label>Id: </label>\{\{ hero.id \}\}</div>
    <div>
      <label>Name: </label>
      <input [(ngModel)]="hero.name" placeholder="name"/>
    </div>
    <p>
      <button (click)="gotoHeroes()">Back</button>
    </p>
  </div>
_END_
		;
		my $component = self.component-toString( %component );
		my $module = self.export-class-toString(
			'HeroDetailComponent', qq:to[_END_], qq:to[_END_], 'OnInit'
  \@HostBinding('\@routeAnimation') routeAnimation = true;
  \@HostBinding('style.display')   display = 'block';
  \@HostBinding('style.position')  position = 'absolute';

  hero: Hero;
_END_
  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private service: HeroService
  ) \{\}

  ngOnInit() \{
    this.route.params
      // (+) converts string 'id' to a number
      .switchMap((params: Params) => this.service.getHero(+params['id']))
      .subscribe((hero: Hero) => this.hero = hero);
  \}

  gotoHeroes() \{
    let heroId = this.hero ? this.hero.id : null;
    // Pass along the hero id if available
    // so that the HeroList component can select that hero.
    // Include a junk 'foo' property for fun.
    this.router.navigate(['/heroes', \{ id: heroId, foo: 'foo' \}]);
  \}
_END_
		);
		return qq:to[_END_];
$imports

$component
$module
_END_
	}

	method hero-list-component {
		my %import = 
			'rxjs/add/operator/switchMap' => Any,
			'rxjs/Observable' => [< Observable >],
			'@angular/core'   => [< Component OnInit >],
			'@angular/router' => [< Router ActivatedRoute Params >],
			'./hero.service'  => [< Hero HeroService >]
		;
		my $imports = self.imports-toString( %import );
		my %component =
			template => q:to[_END_],
    <h2>HEROES</h2>
    <ul class="items">
      <li *ngFor="let hero of heroes | async"
        [class.selected]="isSelected(hero)"
        (click)="onSelect(hero)">
        <span class="badge">\{\{ hero.id \}\}</span> \{\{ hero.name \}\}
      </li>
    </ul>

    <button routerLink="/sidekicks">Go to sidekicks</button>
_END_
		;
		my $component = self.component-toString( %component );
		my $module = self.export-class-toString(
			'HeroListComponent', qq:to[_END_], qq:to[_END_], 'OnInit'
  heroes: Observable\<Hero\[\]\>;

  private selectedId: number;
_END_
  constructor(
    private service: HeroService,
    private route: ActivatedRoute,
    private router: Router
  ) \{\}

  ngOnInit() \{
    this.heroes = this.route.params
      .switchMap((params: Params) => \{
        this.selectedId = +params['id'];
        return this.service.getHeroes();
      \});
  \}

  isSelected(hero: Hero) \{ return hero.id === this.selectedId; \}

  onSelect(hero: Hero) \{
    this.router.navigate(['/hero', hero.id]);
  \}
_END_
		);
		return qq:to[_END_];
// TODO SOMEDAY: Feature Componetized like CrisisCenter
$imports

$component
$module
_END_
	}

	method hero-service {
		my %import =
			'@angular/core' => [< Injectable >]
		;
		my $import = self.imports-toString( %import );
		my $heroModule = self.export-class-toString(
			'Hero', '', qq:to[_END_],
  constructor(public id: number, public name: string) \{ \}
_END_
		);
		my $heroServiceModule = self.export-class-toString(
			'HeroService', '', qq:to[_END_],
  getHeroes() \{ return heroesPromise; \}

  getHero(id: number | string) \{
    return heroesPromise
      .then(heroes => heroes.find(hero => hero.id === +id));
  \}
_END_
		);
		my $injectable = self.injectable-toString();
		return qq:to[_END_];
$import

$heroModule

let HEROES = [
  new Hero(11, 'Mr. Nice'),
  new Hero(12, 'Narco'),
  new Hero(13, 'Bombasto'),
  new Hero(14, 'Celeritas'),
  new Hero(15, 'Magneta'),
  new Hero(16, 'RubberMan')
];

let heroesPromise = Promise.resolve(HEROES);

$injectable
$heroServiceModule
_END_
	}

	method heroes-routing-module {
		my %import =
			'@angular/core'   => [< NgModule >],
			'@angular/router' => [< RouterModule Routes >],

			'./hero-list.component'   => [< HeroListComponent >],
			'./hero-detail.component' => [< HeroDetailComponent >]
		;
		my $import = self.imports-toString( %import );
		my %ngModule =
			imports => [ 'RouterModule.forChild(heroesRoutes)' ],
			exports => [ 'RouterModule' ],
		;
		my $ngModule = self.ngModule-toString( %ngModule );
		my $module = self.export-class-toString(
			'HeroRoutingModule', '', ''
		);
		return qq:to[_END_];
$import

const heroesRoutes: Routes = [
  \{ path: 'heroes',  component: HeroListComponent \},
  \{ path: 'hero/:id', component: HeroDetailComponent \}
];

$ngModule
$module
_END_
	}

	method heroes-module {
		my %import =
			'@angular/core'   => [< NgModule >],
			'@angular/common' => [< CommonModule >],
			'@angular/forms'  => [< FormsModule >],

			'./hero-list.component'   => [< HeroListComponent >],
			'./hero-detail.component' => [< HeroDetailComponent >],

			'./hero.service' => [< HeroService >],

			'./heroes-routing.module' => [< HeroRoutingModule >]
		;
		my $import = self.imports-toString( %import );
		my %ngModule = 
			imports =>
				[< CommonModule FormsModule HeroRoutingModule >],
			declarations =>
				[< HeroListComponent HeroDetailComponent >],
			providers => [< HeroService >]
		;
		my $ngModule = self.ngModule-toString( %ngModule );
		my $module = self.export-class-toString(
			'HeroesModule', '', ''
		);
		return qq:to[_END_];
$import

$ngModule
$module
_END_
	}

	method generate-files {
		my $fh = open :w, "./src/app/heroes/hero-detail.component.ts";
		$fh.say( self.hero-detail-component() );
		$fh.close;

		$fh = open :w, "./src/app/heroes/hero-list.component.ts";
		$fh.say( self.hero-list-component() );
		$fh.close;

		$fh = open :w, "./src/app/heroes/hero.service.ts";
		$fh.say( self.hero-service() );
		$fh.close;

		$fh = open :w, "./src/app/heroes/heroes-routing.module.ts";
		$fh.say( self.heroes-routing-module() );
		$fh.close;

		$fh = open :w, "./src/app/heroes/heroes.module.ts";
		$fh.say( self.heroes-module() );
		$fh.close;
	}
}

sub MAIN {
	my $sample-hero = Sample-Hero.new;
	$sample-hero.generate-files;
}
