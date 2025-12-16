import Route from '@ember/routing/route';
// import { STATUS_OPTIONS, PRIORITY_OPTIONS, SOURCE_OPTIONS } from '../../constants';
import { service } from '@ember/service';
import { getStatusOptions } from '../../utils/getStatusOptions';
export default class AppCreateTicketRoute extends Route {
  @service session;
  @service api;
  @service enumsService;

  async model() {
    const usersResponse = await this.api.getJson('/api/version1/users');
    const users = usersResponse || [];

    return {
      requestor: this.session.email || '',
      title: '',
      description: '',
      assign_to: null,
      statusOptions: await getStatusOptions(
        this.session.role,
        'open',
        this.enumsService.properties?.status_transitions,
        this.enumsService.properties?.status
      ),
      priorityOptions: this.enumsService.properties?.priority || [],
      sourceOptions: this.enumsService.properties?.source || [],
      status: 'open',
      priority: this.enumsService.properties?.priority?.[0]?.value || '',
      source: this.enumsService.properties?.source?.[0]?.value || '',
      attachments: [],
      users: users,
    };
  }
}
