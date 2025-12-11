import Component from '@glimmer/component';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import includes from 'ticket-desk/helpers/includes';

export default class CheckboxGroupComponent extends Component {
  get selectedValues() {
    return this.args.selected ?? [];
  }

  @action
  toggleOption(option) {
    let updated = [...this.selectedValues];

    if (updated.includes(option)) {
      updated = updated.filter((o) => o !== option);
    } else {
      updated.push(option);
    }

    if (this.args.onChange) {
      this.args.onChange(updated);
    }
  }

  <template>
    <div>
      <label class="block text-sm font-normal text-gray-900 mb-2">{{@label}}</label>
      <div class="flex flex-col space-y-3">
        {{#each this.args.options as |opt|}}
          <label class="flex items-center gap-3 cursor-pointer transition-colors">
            <input
              type="checkbox"
              class="h-3 w-3 rounded border-gray-400 text-blue-600 focus:ring-blue-500"
              checked={{includes this.selectedValues opt}}
              {{on "change" (fn this.toggleOption opt)}}
            />
            <span class="text-xs text-gray-800">
              {{opt}}
            </span>
          </label>
        {{/each}}
      </div>
    </div>
  </template>
}
