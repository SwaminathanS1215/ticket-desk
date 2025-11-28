import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AppTicketController extends Controller {
  @service api;

  @tracked page = 1;
  @tracked model;
  @tracked sortBy = 'id'; // default sort field
  @tracked sortOrder = 'asc'; // asc or desc

  itemsPerPage = 10;

  // Main sorted ticket list
  get tickets() {
    if (!this.model?.tickets) return [];

    let sorted = [...this.model.tickets];

    sorted.sort((a, b) => {
      let fieldA = a[this.sortBy];
      let fieldB = b[this.sortBy];

      // Convert strings to lowercase to avoid mismatch
      if (typeof fieldA === 'string') fieldA = fieldA.toLowerCase();
      if (typeof fieldB === 'string') fieldB = fieldB.toLowerCase();

      if (fieldA < fieldB) return this.sortOrder === 'asc' ? -1 : 1;
      if (fieldA > fieldB) return this.sortOrder === 'asc' ? 1 : -1;
      return 0;
    });

    return sorted;
  }

  get totalTickets() {
    return this.tickets.length;
  }

  get totalPages() {
    return Math.ceil(this.totalTickets / this.itemsPerPage);
  }

  get paginatedTickets() {
    const start = (this.page - 1) * this.itemsPerPage;
    return this.tickets.slice(start, start + this.itemsPerPage);
  }

  @action
  nextPage() {
    if (this.page < this.totalPages) {
      this.page++;
    }
  }

  @action
  prevPage() {
    if (this.page > 1) {
      this.page--;
    }
  }

  @action
  async refreshTickets() {
    try {
      const response = await this.api.getJson('/api/version1/tickets');
      this.model = { ...this.model, tickets: response };

      // Re-sort after refreshing
      this.applySorting(this.sortBy);

      console.log('Tickets refreshed successfully');
    } catch (error) {
      console.error('Error refreshing tickets:', error);
      alert('Failed to refresh tickets. Please try again.');
    }
  }

  @action
  async deleteTicket(ticketId) {
    try {
      await this.api.deleteTicket(`/api/version1/tickets/${ticketId}`);
      console.log('Ticket deleted:', ticketId);

      await this.refreshTickets();

      if (this.paginatedTickets.length === 0 && this.page > 1) {
        this.page--;
      }
    } catch (error) {
      console.error('Error deleting ticket:', error);
      alert('Failed to delete ticket.');
    }
  }

  /**
   * 🔥 Sorting Action
   */
  @action
  applySorting(field, order) {
    console.log('fieldorder', field, order);
    // if (this.sortBy === field) {
    //   // Toggle order if same field clicked again
    //   this.sortOrder = this.sortOrder === 'asc' ? 'desc' : 'asc';
    // } else {
    // Reset to ascending when switching fields
    this.sortBy = field.value;
    this.sortOrder = order;
    // }

    // Reset to page 1 after sorting
    this.page = 1;
  }
}
