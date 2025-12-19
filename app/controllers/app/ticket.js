import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';
import { buildRansackQuery } from '../../utils/ticketHelperFunctions';

export default class TicketController extends Controller {
  @service api;
  @service router;

  // URL Synced Query Params
  queryParams = ['page', 'per_page', 'sortBy', 'sortOrder', 'filterData'];

  @tracked page = 1;
  @tracked per_page = 5;

  @tracked sortBy = 'id';
  @tracked sortOrder = 'asc';

  @tracked filterData = ''; // filter (open/closed/etc.)

  /**
   * 🟦 Pagination Actions
   */
  @action setPage(opt) {
    this.per_page = opt;
  }
  @action
  nextPage() {
    this.page = Number(this.page) + 1;
  }

  @action
  prevPage() {
    if (this.page > 1) {
      this.page = Number(this.page) - 1;
    }
  }

  @action
  goToPage(pageNumber) {
    if (pageNumber >= 1) {
      this.page = Number(pageNumber);
    }
  }

  /**
   * 🟩 Sorting Action
   */
  @action
  applySorting(field, order) {
    console.log('fieldfield', field, order);
    this.sortBy = field.value;
    this.sortOrder = order;
    this.page = 1;
  }

  @action
  applyFilters(values) {
    const queryParams = buildRansackQuery(values);
    this.filterData = queryParams;
    console.log('valuesvalues', queryParams);
  }

  @action
  onReset() {
    this.filterData = '';
  }

  /**
   * 🟥 Delete Ticket + Refresh
   */
  @action
  async deleteTicket(ticketId) {
    try {
      await this.api.delete(`/api/version1/tickets/${ticketId}`);

      // Keep same params; route will refresh model
      // this.page = this.page; // triggers refresh silently
      this.router.refresh();
    } catch (e) {
      console.error('Delete error:', e);
      alert('Failed to delete ticket.');
    }
  }
}
