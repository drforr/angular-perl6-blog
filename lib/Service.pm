class Service {
	method crisis-service {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This         = 'CrisisService';
		my $service-file = 'crisis.service';
		my $fetch-method = 'getCrises';
		my $jump-method  = 'gotoCrises';
		my $Type         = 'Crisis';
		my $item         = 'crisis';
		my $collection   = 'crises';
		return qq:to[_END_];
export class {$Type} \{
  constructor(public id: number, public name: string) \{ \}
\}

const CRISES = [
  new {$Type}(1, 'Dragon Burning Cities'),
  new {$Type}(2, 'Sky Rains Great White Sharks'),
  new {$Type}(3, 'Giant Asteroid Heading For Earth'),
  new {$Type}(4, 'Procrastinators Meeting Delayed Again'),
];

let crisesPromise = Promise.resolve(CRISES);

import \{ Injectable \} from '\@angular/core';

\@Injectable()
export class {$This} \{

  static nextCrisisId = 100;

  getCrises() \{ return crisesPromise; \}

  getCrisis(id: number | string) \{
    return crisesPromise
      .then({$collection} => {$collection}.find({$item} => {$item}.id === +id));
  \}

  addCrisis(name: string) \{
    name = name.trim();
    if (name) \{
      let {$item} = new {$Type}({$This}.nextCrisisId++, name);
      crisesPromise.then({$collection} => {$collection}.push({$item}));
    \}
  \}
\}

_END_
	}

	method hero-service {
		# Just to help keep things straight, capitalize the variable
		# name as well.
		#
		my $This         = 'HeroService';
		my $service-file = 'hero.service';
		my $fetch-method = 'getHero';
		my $jump-method  = 'gotoHeroes';
		my $Type         = 'Hero';
		my $item         = 'hero';
		my $collection   = 'heroes';
		return qq:to[_END_];
import \{ Injectable \} from '\@angular/core';

export class Hero \{
  constructor(public id: number, public name: string) \{ \}
\}

let HEROES = [
  new Hero(11, 'Mr. Nice'),
  new Hero(12, 'Narco'),
  new Hero(13, 'Bombasto'),
  new Hero(14, 'Celeritas'),
  new Hero(15, 'Magneta'),
  new Hero(16, 'RubberMan')
];

let heroesPromise = Promise.resolve(HEROES);

\@Injectable()
export class HeroService \{
  getHeroes() \{ return heroesPromise; \}

  getHero(id: number | string) \{
    return heroesPromise
      .then(heroes => heroes.find(hero => hero.id === +id));
  \}
\}
_END_
	}
}
