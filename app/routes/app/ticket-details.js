import Route from '@ember/routing/route';

export default class TicketDetailsRoute extends Route {
  async model(params) {
    // Get id from URL
    let { id } = params;

    // Example: API call to fetch ticket details
    // let response = await fetch(`/api/tickets/${id}`);
    // let ticket = await response.json();
    console.log('id', id);

    // Return the ticket data to template
    return {
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
    };
  }
}
