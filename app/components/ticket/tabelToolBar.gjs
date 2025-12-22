import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { tracked } from '@glimmer/tracking';
import SearchDropdown from 'ticket-desk/components/ticket/searchDropDown.gjs';
import isEqual from 'ticket-desk/helpers/is-equal';
import { fn } from '@ember/helper';

export default class TableToolbar extends Component {
  sortFields = [
    { value: 'title', label: 'Subject' },
    { value: 'requestor', label: 'Requestor' },
    { value: 'status', label: 'Status' },
    { value: 'priority', label: 'Priority' },

    { value: 'source', label: 'Source' },
  ];
  @tracked selectedSort = null;
  @tracked selectedOrder = 'asc';

  @action handleSort(event) {
    // this.args.onSort?.(event.target.value);
  }

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
    this.args.onSortOrder(item, this.selectedOrder);
  }
  @action onOrderSortSelect(item) {
    this.selectedOrder = item;
    this.args.onSortOrder(this.selectedSort, item);
  }

  @action setupSelectAll(element) {
    element.indeterminate = this.args.isPartialSelected;
  }
  @action handleSelectAll(event) {
    this.args.onSelectAll?.(event.target.checked);
  }

  <template>
    <div class="flex items-center justify-between pb-3">

      {{! Left group: Select & Sort }}
      <div class="flex items-center space-x-4">

        {{! Select All }}
        <label class="flex items-center space-x-2 cursor-pointer">
          <input
            type="checkbox"
            class="h-4 w-4 border-gray-300 rounded cursor-pointer"
            checked={{@isAllSelected}}
            {{on "change" this.handleSelectAll}}
          />
          <span class="text-sm text-gray-700">
            Select all
          </span>
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
          total
          {{this.args.total}}
        </span>

        {{! Prev }}
        <button
          class="px-4 py-2 rounded-md border-2 hover:cursor-pointer border-gray-300 bg-transparent text-gray-700 font-medium transition-all duration-200 hover:bg-gray-100 hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-400 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-transparent"
          type="button"
          disabled={{isEqual this.args.page 1}}
          {{on "click" @onPrev}}
        >
          ←
        </button>

        {{! Next }}
        <button
          class="px-4 py-2 rounded-md border-2 hover:cursor-pointer border-gray-300 bg-transparent text-gray-700 font-medium transition-all duration-200 hover:bg-gray-100 hover:border-gray-400 focus:outline-none focus:ring-2 focus:ring-gray-400 disabled:opacity-40 disabled:cursor-not-allowed disabled:hover:bg-transparent"
          type="button"
          {{!-- disabled={{this.args.disableNext}} --}}
          disabled={{isEqual this.args.nextPageEnabled null}}
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
