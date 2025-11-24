import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

export default class AppTicketController extends Controller {
  @tracked page = 1;
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
}
