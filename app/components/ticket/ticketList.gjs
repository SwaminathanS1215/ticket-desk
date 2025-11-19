import Component from '@glimmer/component';
import TicketTable from 'ticket-desk/components/ticket/ticketTable.gjs';
import TableToolbar from 'ticket-desk/components/ticket/tabelToolBar.gjs';
const tabelHeader = [
  {
    id: 'checkbox',
    title: '',
    render: (ticket) => `<input type='checkbox'/>`,
    isCheckbox: true,
  },
  {
    id: 'subject',
    title: 'Subject',
    render: (ticket) => ticket.subject,
  },
  {
    id: 'requester',
    title: 'Requester',
    render: (ticket) => ticket.requester?.name,
  },
  {
    id: 'state',
    title: 'State',
    render: (ticket) => ticket.state,
  },
  {
    id: 'status',
    title: 'Status',
    render: (ticket) => ticket.ticket_status?.name,
  },
  {
    id: 'priority',
    title: 'Priority',
    render: (ticket) => ticket.priority,
  },
  {
    id: 'assigned_to',
    title: 'Assigned To',
    render: (ticket) => ticket.assigned_to,
  },
  {
    id: 'status_details',
    title: 'Status Details',
    render: (ticket) => ticket.status_details,
  },
];

export default class TicketList extends Component {
  constructor() {
    super(...arguments);
    // Or, for specific arguments:
    console.log('Modal data:', this.args.tableData);
  }
  // console.log("net", @tableData)
  <template>
    <TableToolbar />
    <TicketTable @tableHeader={{tabelHeader}} @tableData={{@tableData}} />
  </template>
}
