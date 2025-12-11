import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { tracked } from '@glimmer/tracking';
// import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../../constants';
import { getStatusOptions } from '../../utils/getStatusOptions';

export default class AppUpdateTicketRoute extends Route {
  @service session;
  @service api;
  @service enumsService;

  @tracked ticket = null;

  async model(params) {
    const usersResponse = await this.api.getJson('/api/version1/users');
    const users = usersResponse || [];
    const ticketRes = await this.api.getJson(`/api/version1/tickets/${params.id}`);
    this.ticket = ticketRes;

    return {
      ...this.ticket?.ticket,
      statusOptions: await this.mapStatus(this.ticket?.ticket?.status),
      priorityOptions: this.enumsService.properties?.priority || [],
      sourceOptions: this.enumsService.properties?.source || [],
      users: users,
    };
  }

  async mapStatus(currentStatus) {
    return await getStatusOptions(
      this.session.role,
      currentStatus,
      this.enumsService.properties?.status_transitions,
      this.enumsService.properties?.status
    );
  }
}
