import Route from '@ember/routing/route';
import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../../constants';
import { service } from '@ember/service';
export default class AppCreateTicketRoute extends Route {
  @service session;
  @service api;

  async model() {
    const usersResponse = await this.api.getJson('/api/version1/users');
    const users = usersResponse || [];

    return {
      requestor: this.session.email || '',
      title: '',
      description: '',
      assign_to: null,
      statusOptions: STATUS_OPTIONS,
      priorityOptions: PRIORITY_OPTIONS,
      sourceOptions: SOURCE_OPTIONS,
      status: STATUS_OPTIONS[0].value,
      priority: PRIORITY_OPTIONS[0].value,
      source: SOURCE_OPTIONS[0],
      attachments: [],
      users: users,
    };
  }
}
