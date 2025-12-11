import Component from '@glimmer/component';
import TicketList from 'ticket-desk/components/ticket/ticketList.gjs';

export default class TicketTemplate extends Component {
  <template>
    <TicketList
      @tableData={{@model.tickets}}
      @pageNumber={{@model.metaData.current_page}}
      @totalPagesNumber={{@model.metaData.total_pages}}
      @page_view={{@controller.per_page}}
      @setPage={{@controller.setPage}}
      @totalLength={{@model.metaData.total_count}}
      @nextPageEnabled={{@model.metaData.next_page}}
      @prevPage={{@controller.prevPage}}
      @nextPage={{@controller.nextPage}}
      @onDelete={{@controller.deleteTicket}}
      @onSort={{@controller.applySorting}}
      @onApplyFilter={{@controller.applyFilters}}
      @filterData={{@controller.filterData}}
      @onReset={{@controller.onReset}}
    />
  </template>
}
