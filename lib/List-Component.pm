class List-Component {
	method crisis-list-component {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This         = 'CrisisListComponent';
		my $Service      = 'CrisisService';
		my $service-file = 'crisis.service';
		my $fetch-method = 'getCrises';
		my $Type         = 'Crisis';
		my $item         = 'crisis';
		my $collection   = 'crises';
		return qq:to[_END_];
import 'rxjs/add/operator/switchMap';
import \{ Observable \}                     from 'rxjs/Observable';
import \{ Component, OnInit \}              from '\@angular/core';
import \{ ActivatedRoute, Router, Params \} from '\@angular/router';
import \{
  {$Type}, {$Service}
\} from './{$service-file}';

\@Component(\{
  template: `
    <h2>{$Type} List</h2>
    <ul class="items">
      <li *ngFor="let {$item} of {$collection} | async"
        [class.selected]="isSelected({$item})"
        (click)="onSelect({$item})">
        <span class="badge">\{\{ {$item}.id \}\}</span>
        \{\{ {$item}.name \}\}
      </li>
    </ul>
    <router-outlet></router-outlet>
  `
\})

export class {$This} implements OnInit \{
  {$collection}: Observable\<{$Type}[]\>;

  private selectedId: number;

  ngOnInit() \{
    this.{$collection} = this.route.params
      .switchMap((params: Params) => \{
        this.selectedId = +params['id'];
        return this.service.{$fetch-method}();
      \});
  \}

  constructor(
    private service: {$Service},
    private route:   ActivatedRoute,
    private router:  Router
  ) \{\}

  isSelected({$item}: {$Type}) \{
    return {$item}.id === this.selectedId;
  \}

  onSelect({$item}: {$Type}) \{
    this.selectedId = {$item}.id;

    // Navigate with relative link
    this.router.navigate([{$item}.id], \{ relativeTo: this.route \});
  \}
\}
_END_
	}

	method hero-list-component {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This         = 'HeroListComponent';
		my $Service      = 'HeroService';
		my $service-file = 'hero.service';
		my $fetch-method = 'getHeroes';
		my $Type         = 'Hero';
		my $item         = 'hero';
		my $collection   = 'heroes';
		return qq:to[_END_];
import 'rxjs/add/operator/switchMap';
import \{ Observable \}                     from 'rxjs/Observable';
import \{ Component, OnInit \}              from '\@angular/core';
import \{ ActivatedRoute, Router, Params \} from '\@angular/router';
import \{
  {$Type}, {$Service}
\} from './{$service-file}';

\@Component(\{
  template: `
    <h2>{$Type} List</h2>
    <ul class="items">
      <li *ngFor="let {$item} of {$collection} | async"
        [class.selected]="isSelected({$item})"
        (click)="onSelect({$item})">
        <span class="badge">\{\{ {$item}.id \}\}</span>
        \{\{ {$item}.name \}\}
      </li>
    </ul>
    <button routerLink="/sidekicks">Go to sidekicks</button>
  `
\})

export class {$This} implements OnInit \{
  {$collection}: Observable\<{$Type}[]\>;

  private selectedId: number;

  ngOnInit() \{
    this.{$collection} = this.route.params
      .switchMap((params: Params) => \{
        this.selectedId = +params['id'];
        return this.service.{$fetch-method}();
      \});
  \}

  constructor(
    private service: {$Service},
    private route:   ActivatedRoute,
    private router:  Router
  ) \{\}

  isSelected({$item}: {$Type}) \{
    return {$item}.id === this.selectedId;
  \}

  onSelect({$item}: {$Type}) \{
    this.router.navigate(['/hero', {$item}.id]);
  \}
\}
_END_
	}
}
