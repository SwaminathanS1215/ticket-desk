import Component from '@glimmer/component';
import TicketList from 'ticket-desk/components/ticket/ticketList.gjs';

export default class TicketTemplate extends Component {
  <template>
    <TicketList
      @tableData={{@controller.paginatedTickets}}
      @pageNumber={{@controller.page}}
      @totalPagesNumber={{@controller.totalPages}}
      @totalLength={{@controller.totalTickets}}
      @prevPage={{@controller.prevPage}}
      @nextPage={{@controller.nextPage}}
    />
  </template>
}
