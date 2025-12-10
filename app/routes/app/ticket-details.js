import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class TicketDetailsRoute extends Route {
  @service api;
  async model(params) {
    let { id } = params;

    // Run all three API calls together
    let [ticketRes, commentsRes, attachmentRes] = await Promise.allSettled([
      this.api.getJson(`api/version1/tickets/${id}`),
      this.api.getJson(`api/version1/tickets/${id}/comments`),
      this.api.getJson(`api/version1/tickets/${id}/attachment`),
    ]);
    // 'http://localhost:3000/api/version1/tickets/cdc6803d/attachment
    // Extract ticket
    let ticket = ticketRes.status === 'fulfilled' ? ticketRes.value.ticket : {};

    console.log('commentscomments', commentsRes);

    // Extract comments
    let comments = commentsRes.status === 'fulfilled' ? commentsRes.value.comments : [];

    // Extract attachment (FAILED? → return empty string)
    let attachment = attachmentRes.status === 'fulfilled' ? attachmentRes.value : '';

    // Return final model object
    return {
      ...ticket,
      comments,
      attachment,
    };
  }

  @action
  refreshModel() {
    this.refresh();
  }
}
