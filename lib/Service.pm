class Service {
	method crisis-service {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This             = 'CrisisService';
		my $service-file     = 'crisis.service';
		my $fetch-all-method = 'getCrises';
		my $fetch-method     = 'getCrisis';
		my $Type             = 'Crisis';
		my $promise          = 'crisesPromise';
		my $item             = 'crisis';
		my $collection       = 'crises';
		return qq:to[_END_];
import \{ Injectable \} from '\@angular/core';

export class {$Type} \{
  constructor(public id: number, public name: string) \{ \}
\}

const CRISES = [
  new {$Type}(1, 'Dragon Burning Cities'),
  new {$Type}(2, 'Sky Rains Great White Sharks'),
  new {$Type}(3, 'Giant Asteroid Heading For Earth'),
  new {$Type}(4, 'Procrastinators Meeting Delayed Again'),
];

let {$promise} = Promise.resolve(CRISES);

\@Injectable()
export class {$This} \{
  {$fetch-all-method}() \{ return {$promise}; \}

  {$fetch-method}(id: number | string) \{
    return {$promise}
      .then({$collection} => {$collection}.find({$item} => {$item}.id === +id));
  \}
\}
_END_
	}

	method hero-service {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This             = 'HeroService';
		my $service-file     = 'hero.service';
		my $fetch-all-method = 'getHeroes';
		my $fetch-method     = 'getHero';
		my $Type             = 'Hero';
		my $promise          = 'heroesPromise';
		my $item             = 'hero';
		my $collection       = 'heroes';
		return qq:to[_END_];
import \{ Injectable \} from '\@angular/core';

export class {$Type} \{
  constructor(public id: number, public name: string) \{ \}
\}

const HEROES = [
  new {$Type}(11, 'Mr. Nice'),
  new {$Type}(12, 'Narco'),
  new {$Type}(13, 'Bombasto'),
  new {$Type}(14, 'Celeritas'),
  new {$Type}(15, 'Magneta'),
  new {$Type}(16, 'RubberMan')
];

let {$promise} = Promise.resolve(HEROES);

\@Injectable()
export class {$This} \{
  {$fetch-all-method}() \{ return {$promise}; \}

  {$fetch-method}(id: number | string) \{
    return {$promise}
      .then({$collection} => {$collection}.find({$item} => {$item}.id === +id));
  \}
\}
_END_
	}
}
