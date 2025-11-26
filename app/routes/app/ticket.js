import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class TicketRoute extends Route {
   @service api;

  model() {
    return this.api.getJson('/api/version1/tickets');
  }
}
