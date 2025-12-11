import Controller from '@ember/controller';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { API_ENDPOINTS } from '../../constants';

export default class AppCreateTicketController extends Controller {
  @service api;
  @service router;
  @service toast;

  @action async createTicket(form) {
    await this.api.postJson(API_ENDPOINTS.CREATE_TICKET, form);
    this.toast.success('Ticket created successfully');
    this.router.transitionTo('app.ticket');
  }
}
