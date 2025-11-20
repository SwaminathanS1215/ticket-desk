import Component from '@glimmer/component';
import TicketTable from 'ticket-desk/components/ticket/ticketTable.gjs';
import TableToolbar from 'ticket-desk/components/ticket/tabelToolBar.gjs';
import FilterSidebarComponent from 'ticket-desk/components/ticket/filterSideBar.gjs';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

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
  // console.log("net", @tableData)

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
        <TableToolbar @toggleFilterSidebar={{this.toggleFilterSidebar}} />
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
