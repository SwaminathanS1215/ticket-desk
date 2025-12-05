import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class TicketRoute extends Route {
  @service api;
  @service toast;

  async model() {
    try {
      const response = await this.api.getJson('/api/version1/tickets');

      return {
        tickets: response?.tickets || [],
      };
    } catch (error) {
      console.error('Error fetching tickets:', error);
      return {
        tickets: [],
        error: 'Failed to load tickets',
      };
    }
  }
}
