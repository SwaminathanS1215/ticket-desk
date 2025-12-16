import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { API_ENDPOINTS } from '../../constants';
import { getStatusOptions } from '../../utils/getStatusOptions';

export default class TicketDetailsRoute extends Route {
  @service api;
  @service enumsService;
  @service session;

  async model(params) {
    let { id } = params;

    // Run all three API calls together
    let [ticketRes, commentsRes, attachmentRes] = await Promise.allSettled([
      await this.fetchTicketDetails(id),
      await this.fetchTicketComments(id),
      // await this.fetchTicketAttachment(id),
      await this.api.getJson(API_ENDPOINTS.FETCH_USERS),
    ]);

    let ticket = ticketRes.status === 'fulfilled' ? ticketRes.value.ticket : {};
    let comments = commentsRes.status === 'fulfilled' ? commentsRes.value.comments : [];
    let attachment = attachmentRes.status === 'fulfilled' ? attachmentRes.value : '';
    let users = [];
    if (attachmentRes.status === 'fulfilled') {
      users = attachmentRes.value || [];
    }

    // Return final model object
    return {
      ticket: {
        ...ticket,
        users,
        statusOptions: await getStatusOptions(
          this.session.role,
          ticket?.status,
          this.enumsService.properties?.status_transitions,
          this.enumsService.properties?.status
        ),
        priorityOptions: this.enumsService.properties?.priority || [],
        sourceOptions: this.enumsService.properties?.source || [],
      },
      comments,
      attachment,
    };
  }

  @action
  refreshModel() {
    this.refresh();
  }

  async fetchTicketDetails(id) {
    return await this.api.getJson(API_ENDPOINTS.FETCH_TICKET_DETAILS(id));
  }

  async fetchTicketComments(id) {
    return await this.api.getJson(API_ENDPOINTS.FETCH_TICKET_COMMENTS(id));
  }

  async fetchTicketAttachment(id) {
    return await this.api.getJson(API_ENDPOINTS.FETCH_TICKET_ATTACHMENT(id));
  }
}
