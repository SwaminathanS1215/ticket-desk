import Component from '@glimmer/component';
import TicketTable from 'ticket-desk/components/ticket/ticketTable.gjs';
import TableToolbar from 'ticket-desk/components/ticket/tabelToolBar.gjs';
import FilterSidebarComponent from 'ticket-desk/components/ticket/filterSideBar.gjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { fn } from '@ember/helper';

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
    id: 'description',
    title: 'Description',
    render: (ticket) => ticket.description,
  },
  {
    id: 'user_name',
    title: 'Requester',
    render: (ticket) => ticket.user_name,
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
    id: 'assigned_to',
    title: 'Assigned To',
    render: (ticket) => ticket.assigned_to,
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
  constructor() {
    super(...arguments);
    // Or, for specific arguments:
    console.log('Modal data:', this.args.prevPage);
  }
  @tracked isFilterSidebarVisible = true;
  get createdOptions() {
    return [
      'Last 6 months',
      'Last 3 months',
      'Last month',
      'Last week',
      'Custom',
    ];
  }

  get priorityOptions() {
    return ['Low', 'Medium', 'High', 'Urgent'];
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
  <template>
    {{! 3. 👈 Conditional logic and transitions applied in the template }}
    <div class="flex gap-2 justify-between -mr-5">
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
        />
        <TicketTable @tableHeader={{tabelHeader}} @tableData={{@tableData}} />
      </div>

      {{! Sidebar: Apply transition and conditional classes for width/hidden state }}
      <div
        class={{if
          this.isFilterSidebarVisible
          "w-2/6 transition-all duration-300"
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
