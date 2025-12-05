import Component from '@glimmer/component';
import TicketTable from 'ticket-desk/components/ticket/ticketTable.gjs';
import TableToolbar from 'ticket-desk/components/ticket/tabelToolBar.gjs';
import FilterSidebarComponent from 'ticket-desk/components/ticket/filterSideBar.gjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';
import { service } from '@ember/service';

function formatDate(dateString) {
  const date = new Date(dateString);

  let dd = String(date.getDate()).padStart(2, '0');
  let mm = String(date.getMonth() + 1).padStart(2, '0');
  let yyyy = date.getFullYear();

  return `${dd}/${mm}/${yyyy}`;
}

const tabelHeader = [
  {
    id: 'checkbox',
    title: '',
    render: (ticket) => `<input type='checkbox'/>`,
    isCheckbox: true,
  },
  {
    id: 'title',
    title: 'Title',
    render: (ticket) => ticket.title,
  },
  {
    id: 'requestor',
    title: 'Requestor',
    render: (ticket) => ticket?.requestor,
  },
  {
    id: 'status',
    title: 'Status',
    render: (ticket) => ticket.status,
  },
  {
    id: 'priority',
    title: 'Priority',
    render: (ticket) => ticket.priority,
  },
  {
    id: 'source',
    title: 'Source',
    render: (ticket) => ticket.source,
  },
  {
    id: 'assign_to',
    title: 'Assigned To',
    render: (ticket) => ticket.assign_to,
  },
  {
    id: 'created_at',
    title: 'Created At',
    render: (ticket) => formatDate(ticket.created_at),
  },
  {
    id: 'updated_at',
    title: 'Updated At',
    render: (ticket) => formatDate(ticket.updated_at),
  },
];

export default class TicketList extends Component {
  @service router;

  constructor() {
    super(...arguments);
    // Or, for specific arguments:
    console.log('Modal data:', this.args.prevPage);
  }
  @tracked isFilterSidebarVisible = false;
  @tracked selectedTickets = new Set();

  get createdOptions() {
    return ['Last 6 months', 'Last 3 months', 'Last month', 'Last week', 'Custom'];
  }

  get priorityOptions() {
    return ['Low', 'Medium', 'High'];
  }

  get urgencyOptions() {
    return ['Low', 'Medium', 'High'];
  }

  get impactOptions() {
    return ['Low', 'Medium', 'High'];
  }

  get typeOptions() {
    return ['Incident', 'Service Request', 'Major Incident'];
  }

  get isAllSelected() {
    return this.selectedTickets.size === this.args.tableData.length;
  }

  get isNoneSelected() {
    return this.selectedTickets.size === 0;
  }

  get isPartialSelected() {
    return !this.isNoneSelected && !this.isAllSelected;
  }
  @action
  toggleFilterSidebar() {
    this.isFilterSidebarVisible = !this.isFilterSidebarVisible;
    console.log('Sidebar Toggled:', this.isFilterSidebarVisible);
  }
  @action
  prevPage() {
    console.log('prevvvvvv', this.args?.prevPage);
    this.args?.prevPage();
  }
  @action
  nextPage() {
    this.args?.nextPage();
  }

  @action toggleTicketSelection(ticketId, isChecked) {
    if (isChecked) {
      this.selectedTickets.add(ticketId);
    } else {
      this.selectedTickets.delete(ticketId);
    }
    this.selectedTickets = new Set(this.selectedTickets); // trigger re-render
  }

  // When toolbar select-all is clicked
  @action toggleSelectAll(isChecked) {
    if (isChecked) {
      this.selectedTickets = new Set(this.args.tableData.map((t) => t.ticket_id));
    } else {
      this.selectedTickets = new Set();
    }
  }

  @action async handleDelete(ticketId) {
    try {
      console.log('Ticket deleted successfully:', ticketId);
      this.selectedTickets.delete(ticketId);
      this.selectedTickets = new Set(this.selectedTickets);
      await this.args.onDelete?.(ticketId);
    } catch (error) {
      console.error('Error deleting ticket:', error);
      alert('An error occurred while deleting the ticket.');
    }
  }

  @action
  handleEdit(ticket) {
    console.log('handleEdit', ticket, this.router.transitionTo);
    // Correct way for Ember with state
    this.router.transitionTo(
      'app.update-ticket', // Route name must match your router.js definition
      ticket.ticket_id // Dynamic segment param
    );
  }

  @action
  handleSort(sortBy, order) {
    this.args.onSort(sortBy, order);
  }

  <template>
    {{! 3. 👈 Conditional logic and transitions applied in the template }}
    <div class="flex gap-2 justify-between -mr-5 w-full h-full">
      {{! Table Width: Adjusts dynamically based on sidebar visibility }}
      <div
        class={{if
          this.isFilterSidebarVisible
          "w-4/6 transition-all duration-300"
          "w-full transition-all duration-300"
        }}
      >
        <TableToolbar
          @toggleFilterSidebar={{this.toggleFilterSidebar}}
          @page={{@pageNumber}}
          @totalPages={{@totalPagesNumber}}
          @total={{@totalLength}}
          @onPrev={{this.prevPage}}
          @onNext={{this.nextPage}}
          @isAllSelected={{this.isAllSelected}}
          @isPartialSelected={{this.isPartialSelected}}
          @onSelectAll={{this.toggleSelectAll}}
          @onSortOrder={{this.handleSort}}
        />
        <TicketTable
          @tableHeader={{tabelHeader}}
          @tableData={{@tableData}}
          @selectedRows={{this.selectedTickets}}
          @onRowSelect={{this.toggleTicketSelection}}
          @onDelete={{this.handleDelete}}
          @onEdit={{this.handleEdit}}
        />
      </div>

      {{! Sidebar: Apply transition and conditional classes for width/hidden state }}
      <div
        class={{if
          this.isFilterSidebarVisible
          "w-2/6 transition-all duration-300 -mt-4"
          "w-0 overflow-hidden transition-all duration-300"
        }}
      >
        {{#if this.isFilterSidebarVisible}}
          <FilterSidebarComponent
            @createdOptions={{this.createdOptions}}
            @priorityOptions={{this.priorityOptions}}
            @urgencyOptions={{this.urgencyOptions}}
            @impactOptions={{this.impactOptions}}
            @typeOptions={{this.typeOptions}}
          />
        {{/if}}
      </div>

    </div>
  </template>
}
