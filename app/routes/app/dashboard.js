import Route from '@ember/routing/route';

export default class DashboardRoute extends Route {
  async model() {
    try {
      const [metricsRes, chartsRes] = await Promise.all([
        fetch('http://localhost:3000/api/version1/dashboard/summary'),
        fetch('http://localhost:3000/api/version1/dashboard/charts')
      ]);

      if (!metricsRes.ok) {
        throw new Error(`Metrics API failed: ${metricsRes.status}`);
      }
      if (!chartsRes.ok) {
        throw new Error(`Charts API failed: ${chartsRes.status}`);
      }

      const metricsData = await metricsRes.json();
      const chartsData = await chartsRes.json();

      return {
        metrics: metricsData.metrics,
        charts: chartsData.charts
      };
    } catch (error) {
      console.error('Error fetching dashboard data:', error);

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
              { label: 'Low', value: 4, color: '#3b82f6' },
              { label: 'Medium', value: 3, color: '#f59e0b' },
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
        ]
      };
    }
  }
}