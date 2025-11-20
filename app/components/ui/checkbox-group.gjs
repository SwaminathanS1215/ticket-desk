import Component from '@glimmer/component';
import { action } from '@ember/object';
import { tracked } from '@glimmer/tracking';
import { on } from '@ember/modifier';
import { fn } from '@ember/helper';
import includes from 'ticket-desk/helpers/includes';

export default class CheckboxGroupComponent extends Component {
  @tracked internalSelected = this.args.selected ?? [];

  @action
  toggleOption(option) {
    let updated = [...this.internalSelected];

    if (updated.includes(option)) {
      updated = updated.filter((o) => o !== option);
    } else {
      updated.push(option);
    }

    this.internalSelected = updated;

    if (this.args.onChange) {
      this.args.onChange(updated);
    }
  }

  <template>
    <div>
      <label
        class="block text-sm font-normal text-gray-900 mb-2"
      >{{@label}}</label>
      <div
        {{! Removed border, padding, background, and shadow from the main container to match the design }}
        class="flex flex-col space-y-3"
      >
        {{#each this.args.options as |opt|}}
          <label
            {{! Simplified the label style for a cleaner look, focusing on vertical stacking and hover effect }}
            class="flex items-center gap-3 cursor-pointer transition-colors"
          >
            <input
              type="checkbox"
              {{! Standard checkbox size and border color. You may need to customize the default appearance via a plugin if the default isn't exactly like the image. }}
              class="h-3 w-3 rounded border-gray-400 text-blue-600 focus:ring-blue-500"
              checked={{includes this.internalSelected opt}}
              {{on "change" (fn this.toggleOption opt)}}
            />

            {{! Adjusted text size and color to be slightly larger and darker }}
            <span class="text-xs text-gray-800">
              {{opt}}
            </span>
          </label>
        {{/each}}
      </div>
    </div>
  </template>
}
