import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class TicketDetailsRoute extends Route {
  @service api;

  async model(params) {
    let { id } = params;
    const response = await this.api.getJson(`/api/version1/tickets/${id}`);
    const comments = await this.api.getJson(`/api/version1/tickets/${id}/comments`);

    console.log('response', comments);

    return {
      ...response.ticket,
      comments: [...comments.comments],
    };
  }

  @action
  refreshModel() {
    this.refresh();
  }
}
