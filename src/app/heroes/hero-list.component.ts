import 'rxjs/add/operator/switchMap';
import { Observable }                     from 'rxjs/Observable';
import { Component, OnInit }              from '@angular/core';
import { ActivatedRoute, Router, Params } from '@angular/router';
import {
  Hero, HeroService
} from './hero.service';

@Component({
  template: `
    <h2>Hero List</h2>
    <ul class="items">
      <li *ngFor="let hero of heroes | async"
        [class.selected]="isSelected(hero)"
        (click)="onSelect(hero)">
        <span class="badge">{{ hero.id }}</span>
        {{ hero.name }}
      </li>
    </ul>
    <button routerLink="/sidekicks">Go to sidekicks</button>
  `
})

export class HeroListComponent implements OnInit {
  heroes: Observable<Hero[]>;

  private selectedId: number;

  ngOnInit() {
    this.heroes = this.route.params
      .switchMap((params: Params) => {
        this.selectedId = +params['id'];
        return this.service.getHeroes();
      });
  }

  constructor(
    private service: HeroService,
    private route:   ActivatedRoute,
    private router:  Router
  ) {}

  isSelected(hero: Hero) {
    return hero.id === this.selectedId;
  }

  onSelect(hero: Hero) {
    this.router.navigate(['/hero', hero.id]);
  }
}

