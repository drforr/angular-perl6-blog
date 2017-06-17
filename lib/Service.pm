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
export class Crisis \{
  constructor(public id: number, public name: string) \{ \}
\}

const CRISES = [
  new Crisis(1, 'Dragon Burning Cities'),
  new Crisis(2, 'Sky Rains Great White Sharks'),
  new Crisis(3, 'Giant Asteroid Heading For Earth'),
  new Crisis(4, 'Procrastinators Meeting Delayed Again'),
];

let crisesPromise = Promise.resolve(CRISES);

import \{ Injectable \} from '\@angular/core';

\@Injectable()
export class CrisisService \{

  static nextCrisisId = 100;

  getCrises() \{ return crisesPromise; \}

  getCrisis(id: number | string) \{
    return crisesPromise
      .then(crises => crises.find(crisis => crisis.id === +id));
  \}

  addCrisis(name: string) \{
    name = name.trim();
    if (name) \{
      let crisis = new Crisis(CrisisService.nextCrisisId++, name);
      crisesPromise.then(crises => crises.push(crisis));
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
