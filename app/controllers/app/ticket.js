// app/controllers/app/ticket.js (Guaranteed Safe)
import Controller from '@ember/controller';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';

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

export default class TicketController extends Controller {
  @tracked page = 1;
  limit = 10;

  get tickets() {
    // This is the robust guard.
    return ticketList || [];
  }

  get totalTickets() {
    return this.tickets.length;
  }

  get totalPages() {
    // Simplest reliable calculation for total pages
    const total = this.totalTickets;
    return Math.ceil(total / this.limit);
  }

  get paginatedTickets() {
    const start = (this.page - 1) * this.limit;
    const end = start + this.limit;
    return this.tickets.slice(start, end);
  }

  @action nextPage() {
    if (this.page < this.totalPages) {
      this.page++;
    }
  }

  @action prevPage() {
    if (this.page > 1) {
      this.page--;
    }
  }
}
