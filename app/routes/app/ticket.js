import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class TicketRoute extends Route {
  async model() {
    try {
      const response = await fetch('http://127.0.0.1:3000/api/version1/tickets', {
        headers: {
          'Content-Type': 'application/json',
          Accept: 'application/json',
          'Access-Control-Allow-Origin': '*',
        },
        method: 'GET',
        mode: 'cors',
      });
      const data = await response.json();

      console.log('API Ticket Response:', data);

      return {
        tickets: data, // assuming API returns an array
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
