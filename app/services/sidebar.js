import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class SidebarService extends Service {
  @tracked collapsed = true;

  get sidebarStyle() {
    return this.collapsed ? 'width: 70px;' : 'width: 248px;';
  }

  get headerStyle() {
    return this.collapsed ? 'left: 70px;' : 'left: 248px;';
  }

  toggle() {
    this.collapsed = !this.collapsed;
  }
}
