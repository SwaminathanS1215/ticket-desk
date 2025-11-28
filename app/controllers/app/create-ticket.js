import Controller from '@ember/controller';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class AppCreateTicketController extends Controller {
  @service api;
  @service router;
  @service toast;

  @action async createTicket(form) {
    console.log('API in controller = ', this.api);
    await this.api.postJson('/api/version1/tickets', form);
    this.toast.success('Ticket created successfully');
    this.router.transitionTo('app.ticket');
  }
}
