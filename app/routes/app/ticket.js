import Route from '@ember/routing/route';
import { service } from '@ember/service';

export default class TicketRoute extends Route {
  @service api;
  @service session;

  queryParams = {
    page: { refreshModel: true },
    per_page: { refreshModel: true },
    sortBy: { refreshModel: true },
    sortOrder: { refreshModel: true },
    filterData: { refreshModel: true },
  };

  async model(params) {
    try {
      const { page, per_page, sortBy, sortOrder, filterData } = params;
      console.log('ffff', filterData);

      let query = `api/version1/tickets?page=${page}&per_page=${per_page}`;
      console.log('fffff', filterData);

      if (filterData) query += `&${filterData}`;
      if (sortBy) query += `&q[s]=${sortBy} ${sortOrder}`;

      const response = await this.api.getJson(query);

      return {
        tickets: response?.tickets || [],
        metaData: response?.meta || {},
        role: this.session.role,
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
