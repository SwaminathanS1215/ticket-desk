import Controller from '@ember/controller';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class AppCreateTicketController extends Controller {
  @service api;
  @service router;

  @action async createTicket(form) {
    console.log('API in controller = ', this.api);
    await this.api.postJson('/api/version1/tickets', form);
    this.router.transitionTo('app.ticket');
  }
}
