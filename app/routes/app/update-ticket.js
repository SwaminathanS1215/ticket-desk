import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../../constants';

export default class AppUpdateTicketRoute extends Route {
  @service session;
  @service api;
  async model(params) {
    const usersResponse = await this.api.getJson('/api/version1/users');
    const users = usersResponse || [];
    const ticket = await this.api.getJson(`/api/version1/tickets/${params.id}`);
    return {
      ...ticket.ticket,
      statusOptions: STATUS_OPTIONS,
      priorityOptions: PRIORITY_OPTIONS,
      sourceOptions: SOURCE_OPTIONS,
      users: users,
    };
  }
}
