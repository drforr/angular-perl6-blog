import 'rxjs/add/operator/switchMap';
import { Component, OnInit, HostBinding } from '@angular/core';
import { Router, ActivatedRoute, Params } from '@angular/router';
import {
  Hero, HeroService
}  from './hero.service';

@Component({
  template: `
  <h2>Hero Detail</h2>
  <div *ngIf="hero">
    <h3>"{{ hero.name }}"</h3>
    <div>
      <label>Id: </label>{{ hero.id }}</div>
    <div>
      <label>Name: </label>
      <input [(ngModel)]="hero.name" placeholder="name"/>
    </div>
    <p>
      <button (click)="cancel()">Cancel</button>
    </p>
  </div>
  `
})

export class HeroDetailComponent implements OnInit {
  hero: Hero;

  constructor(
    private route:   ActivatedRoute,
    private router:  Router,
    private service: HeroService
  ) {}

  cancel() {
    this.gotoHeroes();
  }

  ngOnInit() {
    this.route.params
      .switchMap((params: Params) => this.service.getHero(+params['id']))
      .subscribe((hero: Hero) => this.hero = hero);
  }

  gotoHeroes() {
    let heroId = this.hero ? this.hero.id : null;
    this.router.navigate(['/heroes', { id: heroId, foo: 'foo' }]);
  }
}

