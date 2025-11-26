import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { service } from '@ember/service';

export default class AppTicketController extends Controller {
  @service api;

  @tracked page = 1;
  @tracked model; // Track the model itself
  itemsPerPage = 10;

  // Access tickets from this.model (passed from route)
  get tickets() {
    return this.model?.tickets || [];
  }

  get totalTickets() {
    return this.tickets.length;
  }

  get totalPages() {
    return Math.ceil(this.totalTickets / this.itemsPerPage);
  }

  get paginatedTickets() {
    const start = (this.page - 1) * this.itemsPerPage;
    const end = start + this.itemsPerPage;
    return this.tickets.slice(start, end);
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
      // Update the model by reassigning it completely
      this.model = { ...this.model, tickets: response };
      console.log('Tickets refreshed successfully');
    } catch (error) {
      console.error('Error refreshing tickets:', error);
      alert('Failed to refresh tickets. Please try again.');
    }
  }

  @action
  async deleteTicket(ticketId) {
    try {
      // Call DELETE API
      await this.api.deleteJson(`/api/version1/tickets/${ticketId}`);

      console.log('Ticket deleted successfully:', ticketId);

      // Refresh the tickets list to get updated data
      await this.refreshTickets();

      // If deleted ticket was on the last page and it's now empty, go to previous page
      if (this.paginatedTickets.length === 0 && this.page > 1) {
        this.page--;
      }

      return true;
    } catch (error) {
      console.error('Error deleting ticket:', error);
      alert('Failed to delete ticket. Please try again.');
      return false;
    }
  }
}
