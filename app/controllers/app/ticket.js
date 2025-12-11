import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';

function buildRansackQuery(filters) {
  const params = [];

  // Helper to format date YYYY-MM-DD
  const formatDate = (date) => {
    return date.toISOString().split('T')[0];
  };

  // 1. Created At → last X days → actual date
  if (filters.created_at?.value) {
    const daysAgo = parseInt(filters.created_at.value, 10);

    const today = new Date(); // today = 09 Dec 2025
    const targetDate = new Date(today);
    targetDate.setDate(today.getDate() - daysAgo); // subtract X days

    const finalDate = formatDate(targetDate); // convert to YYYY-MM-DD

    params.push(`q[created_at_gteq]=${finalDate}`);
  }

  // 2. Status (single value)
  if (filters.status) {
    params.push(`q[status_eq]=${encodeURIComponent(filters.status)}`);
  }

  // 3. Priority (array → _in)
  if (Array.isArray(filters.priority) && filters.priority.length > 0) {
    filters.priority.forEach((p) => {
      params.push(`q[priority_in][]=${encodeURIComponent(p.toLowerCase())}`);
    });
  }

  // 4. Source (single value)
  if (filters.source) {
    params.push(`q[source_eq]=${encodeURIComponent(filters.source)}`);
  }

  return params.join('&');
}

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
      await this.api.deleteTicket(`/api/version1/tickets/${ticketId}`);

      // Keep same params; route will refresh model
      // this.page = this.page; // triggers refresh silently
      this.router.refresh();
    } catch (e) {
      console.error('Delete error:', e);
      alert('Failed to delete ticket.');
    }
  }
}
