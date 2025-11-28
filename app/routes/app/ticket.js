import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class TicketRoute extends Route {
  @service api;

  async model() {
    try {
      const response = await this.api.getJson('/api/version1/tickets');

      return {
        tickets: response, // assuming API returns an array
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
