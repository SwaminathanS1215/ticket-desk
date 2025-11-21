import Component from '@glimmer/component';
import TicketList from 'ticket-desk/components/ticket/ticketList.gjs';
import { fn } from '@ember/helper';

export default class TicketTemplate extends Component {
  constructor() {
    super(...arguments);
    console.log('hhhhhh', this);
  }
  <template>
    <TicketList
      @tableData={{this.paginatedTickets}}
      @pageNumber={{this.page}}
      @totalPagesNumber={{this.totalPages}}
      @totalLength={{this.totalTickets}}
      @prevPage={{this.prevPage}}
      @nextPage={{this.nextPage}}
    />
  </template>
}
