// components/custom-select.gjs
import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import isEqual from 'ticket-desk/helpers/is-equal';
import { fn } from '@ember/helper';
import clickOutside from 'ticket-desk/modifiers/click-outside.js';

export default class CustomSelectComponent extends Component {
  // ... (Constructor and tracked properties remain the same) ...
  @tracked isOpen = false;

  get displayValue() {
    return this.args.value || this.args.placeholder || 'Select';
  }

  @action
  toggleDropdown() {
    console.log('cicking', this.isOpen);
    this.isOpen = !this.isOpen;
  }

  @action
  selectOption(option) {
    this.isOpen = false;
    if (this.args.onChange) {
      this.args.onChange(option);
    }
  }

  @action
  // This action will be called by the custom modifier when a click happens outside the wrapper.
  handleClickOutside() {
    this.isOpen = false;
  }

  <template>
    <div
      {{! 
        1. Place the conditional modifier block immediately after the opening <div>. 
        2. Ensure there is absolutely NO HTML or text outside this main <div> 
           in the template.
      }}
      {{clickOutside this.handleClickOutside condition=this.isOpen}}
    >
      <label
        class="block text-sm font-normal text-gray-900 mb-2"
      >{{@label}}</label>
      <div
        class="custom-select-wrapper relative"
        {{on "click" this.toggleDropdown}}
      >
        {{! ... The rest of the content is fine ... }}
        <div
          class="w-full px-3 py-2 text-sm border border-gray-300 rounded bg-white focus:outline-none focus:ring-1 focus:ring-blue-500 focus:border-blue-500 cursor-pointer flex items-center justify-between
            {{if @value 'text-gray-700' 'text-gray-500'}}"
        >
          <span>{{this.displayValue}}</span>
          <span class="text-gray-400 pointer-events-none">▼</span>
        </div>

        {{#if this.isOpen}}
          <div
            class="absolute z-50 w-full mt-1 bg-white border border-gray-300 rounded shadow-lg max-h-60 overflow-y-auto"
          >
            {{#if @options}}
              {{#each @options as |option|}}
                <div
                  class="px-3 py-2 text-sm hover:bg-gray-100 cursor-pointer
                    {{if
                      (isEqual @value option)
                      'bg-blue-50 text-blue-600'
                      'text-gray-700'
                    }}"
                  {{on "click" (fn this.selectOption option)}}
                >
                  {{option}}
                </div>
              {{/each}}
            {{else}}
              <div class="px-3 py-2 text-sm text-gray-500">No options available</div>
            {{/if}}
          </div>
        {{/if}}
      </div>
    </div>
  </template>
}
