import Route from '@ember/routing/route';

export default class DashboardRoute extends Route {
  model() {
    return {
      metrics: [
        { id: 1, title: 'Overdue Tickets', count: 5, isAlert: true },
        { id: 2, title: 'Tickets Due Today', count: 1, isAlert: false },
        { id: 3, title: 'Open tickets', count: 8, isAlert: false },
        { id: 4, title: 'Tickets On Hold', count: 0, isAlert: false },
        { id: 5, title: 'Unassigned Tickets', count: 8, isAlert: true },
        { id: 6, title: "Tickets I'm Watching", count: 0, isAlert: false },
      ],
      
      charts: [
        {
          id: 'priority',
          type: 'pie',
          title: 'Unresolved Tickets by Priority',
          data: [
            { label: 'High', value: 1, color: '#8b5cf6' },
            { label: 'Medium', value: 3, color: '#f59e0b' },
            { label: 'Low', value: 4, color: '#3b82f6' },
          ],
        },
        {
          id: 'status',
          type: 'pie',
          title: 'Unresolved Tickets by Status',
          data: [{ label: 'Open', value: 8, color: '#3b82f6' }],
        },
        {
          id: 'open',
          type: 'bar',
          title: 'New & My Open Tickets',
          data: [
            { label: 'Low', value: 4, color: '#ec4899' },
            { label: 'Medium', value: 3, color: '#ec4899' },
            { label: 'High', value: 1, color: '#ec4899' },
            { label: 'Urgent', value: 0, color: '#ec4899' },
          ],
        },
      ],
    };
  }
}
