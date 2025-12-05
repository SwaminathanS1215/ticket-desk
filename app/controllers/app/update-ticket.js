import Controller from '@ember/controller';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class AppUpdateTicketController extends Controller {
  @service api;
  @service router;
  @service toast;

  @action async updateTicket(form) {
    console.log('API in controller = ', form);
    await this.api.putJson(`/api/version1/tickets/${form.ticket_id}`, form);
    this.toast.success('Ticket updated successfully');
    this.router.transitionTo('app.ticket');
  }
}
