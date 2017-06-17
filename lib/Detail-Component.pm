class Detail-Component {
	method crisis-detail-component {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This         = 'CrisisDetailComponent';
		my $service-file = 'crisis.service';
		my $fetch-method = 'getCrises';
		my $jump-method  = 'gotoCrises';
		my $Type         = 'Crisis';
		my $item         = 'crisis';
		my $collection   = 'crises';
		return qq:to[_END_];
import \{ Component, OnInit, HostBinding \} from '\@angular/core';
import \{ ActivatedRoute, Router \}         from '\@angular/router';
import \{ DialogService \}                  from '../dialog.service';
import \{
  {$Type}
\} from './{$service-file}';

\@Component(\{
  template: `
  <h2>{$Type} Detail</h2>
  <div *ngIf="{$item}">
    <h3>"\{\{ editName \}\}"</h3>
    <div>
      <label>Id: </label>\{\{ {$item}.id \}\}</div>
    <div>
      <label>Name: </label>
      <input [(ngModel)]="editName" placeholder="name"/>
    </div>
    <p>
      <button (click)="save()">Save</button>
      <button (click)="cancel()">Cancel</button>
    </p>
  </div>
  `
\})

export class {$This} implements OnInit \{
  {$item}: {$Type};
  editName: string;

  constructor(
    private route:         ActivatedRoute,
    private router:        Router,
    public  dialogService: DialogService
  ) \{\}

  ngOnInit() \{
    this.route.data
      .subscribe((data: \{ {$item}: {$Type} \}) => \{
        this.editName = data.{$item}.name;
        this.{$item} = data.{$item};
      \});
  \}

  cancel() \{
    this.{$jump-method}();
  \}

  save() \{
    this.{$item}.name = this.editName;
    this.{$jump-method}();
  \}

  canDeactivate(): Promise<boolean> | boolean \{
    if (!this.{$item} || this.{$item}.name === this.editName) \{
      return true;
    \}
    return this.dialogService.confirm('Discard changes?');
  \}

  {$jump-method}() \{
    let crisisId = this.{$item} ? this.{$item}.id : null;
    this.router.navigate(['../', \{ id: crisisId, foo: 'foo' \}], \{
      relativeTo: this.route
    \});
  \}
\}
_END_
	}

	method hero-detail-component {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This         = 'HeroDetailComponent';
		my $Service      = 'HeroService';
		my $service-file = 'hero.service';
		my $fetch-method = 'getHero';
		my $jump-method  = 'gotoHeroes';
		my $Type         = 'Hero';
		my $item         = 'hero';
		my $collection   = 'heroes';
		return qq:to[_END_];
import 'rxjs/add/operator/switchMap';
import \{ Component, OnInit, HostBinding \} from '\@angular/core';
import \{ Router, ActivatedRoute, Params \} from '\@angular/router';
import \{
  {$Type}, {$Service}
\}  from './{$service-file}';

\@Component(\{
  template: `
  <h2>{$Type} Detail</h2>
  <div *ngIf="{$item}">
    <h3>"\{\{ {$item}.name \}\}"</h3>
    <div>
      <label>Id: </label>\{\{ {$item}.id \}\}</div>
    <div>
      <label>Name: </label>
      <input [(ngModel)]="{$item}.name" placeholder="name"/>
    </div>
    <p>
      <button (click)="cancel()">Cancel</button>
    </p>
  </div>
  `
\})

export class {$This} implements OnInit \{
  {$item}: {$Type};

  constructor(
    private route:   ActivatedRoute,
    private router:  Router,
    private service: {$Service}
  ) \{\}

  cancel() \{
    this.{$jump-method}();
  \}

  ngOnInit() \{
    this.route.params
      .switchMap((params: Params) => this.service.{$fetch-method}(+params['id']))
      .subscribe(({$item}: {$Type}) => this.{$item} = {$item});
  \}

  {$jump-method}() \{
    let heroId = this.{$item} ? this.{$item}.id : null;
    this.router.navigate(['/heroes', \{ id: heroId, foo: 'foo' \}]);
  \}
\}
_END_
	}
}
