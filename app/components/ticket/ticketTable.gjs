import Component from '@glimmer/component';
import Checkbox from 'ticket-desk/components/ui/checkbox.gjs';
import DeleteModal from 'ticket-desk/components/ui/deleteModal.gjs';
import isEqual from 'ticket-desk/helpers/is-equal';
import { LinkTo } from '@ember/routing';
import { fn } from '@ember/helper';
import { on } from '@ember/modifier';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';

export default class TicketTable extends Component {
  @tracked isDeleteModalOpen = false;
  @tracked ticketToDelete = null;

  get headers() {
    return this.args.tableHeader ?? [];
  }

  get rows() {
    return this.args.tableData ?? [];
  }

  get isRowSelected() {
    return (ticketId) => {
      return this.args.selectedRows.has(ticketId);
    };
  }

  @action rowSelectionHandler(ticketId, event) {
    console.log('Selected rows:', this.args.selectedRows);
    this.args.onRowSelect?.(ticketId, event.target.checked);
  }

  @action openDeleteModal(ticket) {
    this.ticketToDelete = ticket;
    this.isDeleteModalOpen = true;
  }

  @action closeDeleteModal() {
    this.isDeleteModalOpen = false;
    this.ticketToDelete = null;
  }

  @action confirmDelete() {
    if (this.ticketToDelete) {
      // Call the parent's delete handler
      this.args.onDelete?.(this.ticketToDelete.ticket_id);
      this.closeDeleteModal();
    }
  }

  @action handleEdit(ticket) {
    // For now, just log - you'll implement this later
    console.log('Edit ticket:', ticket);
    this.args.onEdit?.(ticket);
  }

  <template>
    <div class="overflow-x-auto rounded-lg border border-gray-200 shadow-sm bg-white">
      <table class="min-w-full text-left border-collapse">
        <thead class="bg-gray-100 border-b border-gray-200">
          <tr>
            {{#each this.headers as |col|}}
              <th class="px-4 py-3 text-sm font-semibold text-gray-700 whitespace-nowrap">
                {{col.title}}
              </th>
            {{/each}}
            <th class="px-4 py-3 text-sm font-semibold text-gray-700 whitespace-nowrap text-center">
              Actions
            </th>
          </tr>
        </thead>

        <tbody>
          {{#each this.rows as |ticket|}}
            <tr class="odd:bg-white even:bg-gray-50 hover:bg-gray-100 transition">
              {{#each this.headers as |col|}}
                <td
                  class="px-4 py-3 text-sm text-gray-900 border-b border-gray-200 whitespace-nowrap"
                >
                  {{#if col.isCheckbox}}
                    <Checkbox
                      @checked={{this.isRowSelected ticket.ticket_id}}
                      @onChange={{fn this.rowSelectionHandler ticket.ticket_id}}
                    />
                  {{else}}
                    {{#if (isEqual col.id "title")}}
                      <LinkTo
                        @route="app.ticket_details"
                        @model={{ticket.ticket_id}}
                        class="text-blue-600 underline"
                      >
                        {{col.render ticket}}
                      </LinkTo>
                    {{else}}
                      {{col.render ticket}}
                    {{/if}}
                  {{/if}}
                </td>
              {{/each}}

              {{! Actions Column }}
              <td class="px-4 py-3 text-sm border-b border-gray-200 whitespace-nowrap">
                <div class="flex items-center justify-center space-x-2">
                  {{! Edit Button }}
                  <button
                    type="button"
                    class="p-2 text-blue-600 hover:bg-blue-50 rounded-md transition-colors cursor-pointer"
                    title="Edit"
                    {{on "click" (fn this.handleEdit ticket)}}
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                      />
                    </svg>
                  </button>

                  {{! Delete Button }}
                  <button
                    type="button"
                    class="p-2 text-red-600 hover:bg-red-50 rounded-md transition-colors cursor-pointer"
                    title="Delete"
                    {{on "click" (fn this.openDeleteModal ticket)}}
                  >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"
                      />
                    </svg>
                  </button>
                </div>
              </td>
            </tr>
          {{/each}}
        </tbody>
      </table>
    </div>

    {{! Delete Confirmation Modal }}
    <DeleteModal
      @isOpen={{this.isDeleteModalOpen}}
      @ticketTitle={{this.ticketToDelete.title}}
      @onConfirm={{this.confirmDelete}}
      @onCancel={{this.closeDeleteModal}}
    />
  </template>
}
