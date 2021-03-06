import { Component } from '@angular/core';

import { NavParams } from 'ionic-angular';

import { AboutPage } from '../about/about';
import { MapPage } from '../map/map';
import { TrainingPage } from '../schedule/schedule';
import { TestListPage } from '../test/test-list/test-list';
import { ExercisePage } from '../exercise/exercise';


@Component({
  templateUrl: 'tabs.html'
})
export class TabsPage {
  // set the root pages for each tab
  tab1Root: any = TestListPage;
  tab2Root: any = TrainingPage;
  tab3Root: any = MapPage;
  tab4Root: any = ExercisePage;
  tab5Root: any = AboutPage;
  mySelectedIndex: number;

  constructor(navParams: NavParams) {
    this.mySelectedIndex = navParams.data.tabIndex || 0;
  }

}
