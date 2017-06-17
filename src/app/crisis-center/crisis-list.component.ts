import 'rxjs/add/operator/switchMap';
import { Observable }                     from 'rxjs/Observable';
import { Component, OnInit }              from '@angular/core';
import { ActivatedRoute, Router, Params } from '@angular/router';
import {
  Crisis, CrisisService
} from './crisis.service';

@Component({
  template: `
    <h2>Crisis List</h2>
    <ul class="items">
      <li *ngFor="let crisis of crises | async"
        [class.selected]="isSelected(crisis)"
        (click)="onSelect(crisis)">
        <span class="badge">{{ crisis.id }}</span>
        {{ crisis.name }}
      </li>
    </ul>
    <router-outlet></router-outlet>
  `
})

export class CrisisListComponent implements OnInit {
  crises: Observable<Crisis[]>;

  private selectedId: number;

  ngOnInit() {
    this.crises = this.route.params
      .switchMap((params: Params) => {
        this.selectedId = +params['id'];
        return this.service.getCrises();
      });
  }

  constructor(
    private service: CrisisService,
    private route:   ActivatedRoute,
    private router:  Router
  ) {}

  isSelected(crisis: Crisis) {
    return crisis.id === this.selectedId;
  }

  onSelect(crisis: Crisis) {
    this.selectedId = crisis.id;

    // Navigate with relative link
    this.router.navigate([crisis.id], { relativeTo: this.route });
  }
}

