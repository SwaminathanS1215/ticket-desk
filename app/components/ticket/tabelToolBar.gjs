import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';

import SearchDropdown from 'ticket-desk/components/ticket/searchDropDown.gjs';

export default class TableToolbar extends Component {
  sortFields = [
    { value: 'subject', label: 'Subject' },
    { value: 'requester', label: 'Requester' },
    { value: 'status', label: 'Status' },
    { value: 'priority', label: 'Priority' },
    { value: 'department', label: 'Department' },
    { value: 'source', label: 'Source' },
  ];
  @tracked selectedSort = null;
  @tracked selectedOrder = 'asc';

  // Trigger parent events
  @action handleSelectAll(event) {
    // this.args.onSelectAll?.(event.target.checked);
  }

  @action handleSort(event) {
    // this.args.onSort?.(event.target.value);
  }

  // @action prevPage() {
  //   console.log('clicking', this.args.onPrev);
  //   this.args.onPrev?.();
  // }

  // @action nextPage() {
  //   this.args.onNext?.();
  // }

  @action exportData() {
    // this.args.onExport?.();
  }

  @action filterAction() {
    console.log('vnmhfhjvhjh');
    this.args.toggleFilterSidebar();
  }
  @action onSortSelect(item) {
    this.selectedSort = item;
    console.log('Selected sort:', item);
  }
  @action onOrderSortSelect(item) {
    this.selectedOrder = item;
  }

  <template>
    <div class="flex items-center justify-between pb-3">

      {{! Left group: Select & Sort }}
      <div class="flex items-center space-x-4">

        {{! Select All }}
        <label class="flex items-center space-x-2 cursor-pointer">
          <input
            type="checkbox"
            class="h-4 w-4 border-gray-300 rounded"
            {{on "change" this.handleSelectAll}}
          />
          <span class="text-sm text-gray-700">Select all</span>
        </label>

        <span class="text-gray-300">|</span>

        {{! Sort dropdown }}
        <div class="flex items-center space-x-2 text-sm">
          <span class="text-gray-600">Sort by:</span>

          <SearchDropdown
            @items={{this.sortFields}}
            @selected={{this.selectedSort}}
            @onSelect={{this.onSortSelect}}
            @selectedOrder={{this.selectedOrder}}
            @onOrderSelect={{this.onOrderSortSelect}}
          />
        </div>
      </div>

      {{! Right group: Export + Pagination + Filter }}
      <div class="flex items-center space-x-3">
        {{! Pagination info }}
        <span class="text-sm text-gray-600">
          {{this.args.page}}/{{this.args.totalPages}}
          of
          {{this.args.total}}
        </span>

        {{! Prev }}
        <button
          class="border border-gray-200 p-2 rounded-md disabled:opacity-40" type="button" {{!-- disabled={{this.args.disablePrev}} --}}
          {{! type="button" }}
          {{on "click" @onPrev}}
        >
          ←
        </button>

        {{! Next }}
        <button
          class="border border-gray-200 p-2 rounded-md disabled:opacity-40" type="button" {{!-- disabled={{this.args.disableNext}} --}}
          {{! type="button" }}
          {{on "click" @onNext}}
        >
          →
        </button>

        {{! Filter button }}
        <button
          class="border border-blue-500 text-blue-600 p-2 rounded-md hover:bg-blue-50"
          type="button"
          {{on "click" this.filterAction}}
        >
          ⎘
        </button>

      </div>
    </div>
  </template>
}
