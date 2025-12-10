import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import { modifier } from 'ember-modifier';
import isEqual from 'ticket-desk/helpers/is-equal';
import clickOutside from 'ticket-desk/modifiers/click-outside.js';

export default class UiDropdown extends Component {
  @tracked isOpen = false;
  @tracked dropdownPosition = 'bottom';
  buttonElement = null;

  get displayValue() {
    return this.args.labelKey
      ? `${this.args.selected} / ${this.args.labelKey}`
      : this.args.selected;
  }

  // Create a modifier to capture the button element
  registerButton = modifier((element) => {
    this.buttonElement = element;
  });

  @action toggle() {
    if (!this.isOpen && this.buttonElement) {
      // Calculate position before opening
      const rect = this.buttonElement.getBoundingClientRect();
      const windowHeight = window.innerHeight;
      const spaceBelow = windowHeight - rect.bottom;
      const spaceAbove = rect.top;
      const dropdownHeight = 200; // Approximate height

      // Open upward if not enough space below and more space above
      if (spaceBelow < dropdownHeight && spaceAbove > spaceBelow) {
        this.dropdownPosition = 'top';
      } else {
        this.dropdownPosition = 'bottom';
      }
    }
    this.isOpen = !this.isOpen;
  }

  @action select(option) {
    this.isOpen = false;
    if (this.args.onChange) {
      this.args.onChange(option);
    }
  }

  @action handleClickOutside(event) {
    if (this.isOpen && !event.target.closest('.dropdown-container')) {
      this.isOpen = false;
    }
  }

  <template>
    <div class="dropdown-container relative inline-block text-left w-fit">

      {{! Trigger Button }}
      <button
        class="px-4 py-2.5 bg-white text-sm font-medium text-gray-700 flex items-center justify-between gap-2 hover:bg-gray-50 transition-colors min-w-[160px] focus:outline-none focus:bg-gray-50 focus:border-none focus:shadow-none"
        {{on "click" this.toggle}}
        {{this.registerButton}}
        {{clickOutside this.toggle condition=this.isOpen}}
      >
        <span>Showing {{this.displayValue}}</span>
        <svg
          class="w-4 h-4 text-gray-500 transition-transform {{if this.isOpen 'rotate-180'}}"
          fill="none"
          stroke="currentColor"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M19 9l-7 7-7-7"
          ></path>
        </svg>
      </button>

      {{! Dropdown Menu }}
      {{#if this.isOpen}}
        <div
          class="absolute z-50 w-full rounded-md bg-white shadow-lg border border-gray-200 py-1 max-h-60 overflow-y-auto
            {{if (isEqual this.dropdownPosition 'top') 'bottom-full mb-1' 'top-full mt-1'}}"
        >
          {{#each this.args.options as |opt|}}
            <div
              class="px-4 py-2.5 text-sm cursor-pointer flex items-center justify-between
                {{if
                  (isEqual opt.value this.args.selected)
                  'bg-blue-50 text-blue-600'
                  'text-gray-700 hover:bg-gray-100'
                }}"
              {{on "click" (fn this.select opt.value)}}
            >
              <span class="{{if (isEqual opt.value this.args.selected) 'font-medium'}}">
                {{opt.label}}
              </span>
              {{#if (isEqual opt.value this.args.selected)}}
                <svg class="w-5 h-5 text-blue-600" fill="currentColor" viewBox="0 0 20 20">
                  <path
                    fill-rule="evenodd"
                    d="M16.707 5.293a1 1 0 010 1.414l-8 8a1 1 0 01-1.414 0l-4-4a1 1 0 011.414-1.414L8 12.586l7.293-7.293a1 1 0 011.414 0z"
                    clip-rule="evenodd"
                  ></path>
                </svg>
              {{/if}}
            </div>
          {{/each}}
        </div>
      {{/if}}
    </div>
  </template>
}
