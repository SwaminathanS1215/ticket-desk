import Route from '@ember/routing/route';
import { service } from '@ember/service';
import { action } from '@ember/object';

export default class TicketRoute extends Route {
  model() {
    const ticketList = [
      // ... your 27 ticket objects here (copied from original) ...
      {
        id: 1,
        created_at: '2025-11-20T08:34:18.791Z',
        description: 'logging issue',
        priority: 'low',
        source: 'phone',
        status: 'resolved',
        ticket_id: '1',
        title: 'Title1',
        updated_at: '2025-11-20T08:34:18.791Z',
        user_name: 'Person1',
      },
      {
        id: 2,
        created_at: '2025-11-20T08:34:18.791Z',
        description: 'logging issue',
        priority: 'low',
        source: 'phone',
        status: 'resolved',
        ticket_id: '2',
        title: 'Title1',
        updated_at: '2025-11-20T08:34:18.791Z',
        user_name: 'Person1',
      },
    ];

    const modelObject = {
      tickets: ticketList,
    };

    // Check what the route returns
    console.log('Route Model Data:', modelObject);

    return modelObject;
  }
}
