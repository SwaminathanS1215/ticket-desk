import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { hash } from '@ember/helper';

import isEqual from 'ticket-desk/helpers/is-equal';

export default class SearchDropdown extends Component {
  @tracked search = '';
  @tracked isOpen = false;

  get filteredItems() {
    let q = this.search.toLowerCase();
    return this.args.items.filter((i) => i.label.toLowerCase().includes(q));
  }

  get selectedLabel() {
    return this.args.selected?.label || 'Select Field';
  }

  @action toggleDropdown() {
    this.isOpen = !this.isOpen;
  }

  @action selectItem(item) {
    console.log('item', item);
    this.args.onSelect?.(item);
    this.isOpen = false;
  }
  @action orderSelect(item) {
    this.args.onOrderSelect(item);
    this.isOpen = false;
  }

  @action updateSearch(e) {
    this.search = e.target.value;
  }

  <template>
    <div class="relative inline-block w-56">

      {{!-- Trigger --}}
      <button
        type="button"
        class="w-full border border-gray-300 bg-white rounded-md px-3 py-2 text-left text-sm hover:bg-gray-50"
        {{on "click" this.toggleDropdown}}
      >
        {{this.selectedLabel}}
      </button>

      {{#if this.isOpen}}
        <div
          class="absolute mt-1 w-full bg-white border border-gray-200 rounded-md shadow-lg z-10"
        >

          {{!-- Search box --}}
          <div class="p-2">
            <input
              type="text"
              placeholder="Search fields"
              class="w-full border border-gray-300 rounded-md px-2 py-1 text-sm focus:ring-blue-500 focus:border-blue-500"
              value={{this.search}}
              {{on "input" this.updateSearch}}
            />
          </div>

          {{!-- Filtered list --}}
          <div class="max-h-56 overflow-y-auto">
            {{#each this.filteredItems as |item|}}
              <button
                class="w-full text-left px-3 py-2 text-sm hover:bg-gray-100 flex justify-between items-center
                  {{if
                    (isEqual this.args.selected.value item.value)
                    'bg-blue-50'
                  }}" type="button" {{on "click" (fn this.selectItem item)}}
              >
                <span>{{item.label}}</span>

                {{#if (isEqual this.args.selected.value item.value)}}
                  <span class="text-blue-600">✔</span>
                {{/if}}
              </button>
            {{/each}}
          </div>

          <div class="border-t my-1"></div>

          {{!-- ASC --}}
          <button
            class="w-full text-left px-3 py-2 text-sm hover:bg-gray-100 flex justify-between
              {{if (isEqual this.args.selectedOrder 'asc') 'bg-blue-50'}}" type="button" {{on "click" (fn this.orderSelect "asc")}}
          >
            <span>Ascending</span>
            {{#if (isEqual this.args.selectedOrder "asc")}}
              <span class="text-blue-600">✔</span>
            {{/if}}
          </button>

          {{!-- DESC --}}
          <button
            class="w-full text-left px-3 py-2 text-sm hover:bg-gray-100 flex justify-between
              {{if (isEqual this.args.selectedOrder 'desc') 'bg-blue-50'}}" type="button" {{on "click" (fn this.orderSelect "desc")}}
          >
            <span>Descending</span>

            {{#if (isEqual this.args.selectedOrder "desc")}}
              <span class="text-blue-600">✔</span>
            {{/if}}
          </button>

        </div>
      {{/if}}
    </div>
  </template>
}
