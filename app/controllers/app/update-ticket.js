import Controller from '@ember/controller';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { API_ENDPOINTS } from '../../constants';

export default class AppUpdateTicketController extends Controller {
  @service api;
  @service router;
  @service toast;

  @action async updateTicket(form) {
    console.log('API in controller = ', form);
    await this.api.putJson(API_ENDPOINTS.UPDATE_TICKET(form.ticket_id), form);
    this.toast.success('Ticket updated successfully');
    this.router.transitionTo('app.ticket');
  }
}
