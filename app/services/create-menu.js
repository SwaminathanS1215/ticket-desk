import Service from '@ember/service';
import { tracked } from '@glimmer/tracking';

export default class CreateMenuService extends Service {
  @tracked open = false;

  toggle() {
    this.open = !this.open;
  }

  close() {
    this.open = false;
  }
}
