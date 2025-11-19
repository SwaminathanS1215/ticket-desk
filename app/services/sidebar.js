import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class SidebarService extends Service {
  @tracked collapsed = false;

  get sidebarStyle() {
    return this.collapsed
      ? "width: 70px;"
      : "width: 260px;";
  }

  toggle() {
    this.collapsed = !this.collapsed;
  }
}
