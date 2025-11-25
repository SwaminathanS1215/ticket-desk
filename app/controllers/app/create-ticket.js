import Controller from '@ember/controller';
import { service } from '@ember/service';

export default class AppCreateTicketController extends Controller {
  @service router;
  @service api;

  async createTicket(form) {
    await this.api.postJson('http://localhost:3000/api/version1/tickets', form);
    this.router.transitionTo('app.ticket');
  }
}
