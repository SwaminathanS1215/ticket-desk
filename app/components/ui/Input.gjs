import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

export default class UiTagInputComponent extends Component {
  // Args:
  // @label = "Tags"
  // @value = tracked string from parent
  // @onChange = (newValue) => {}

  @tracked search = this.args.value ?? '';

  @action
  updateSearch(e) {
    this.search = e.target.value;

    if (typeof this.args.onChange === 'function') {
      this.args.onChange(this.search);
    }
  }

  <template>
    <div>
      <label class="block text-sm font-normal text-gray-900 mb-2">
        {{@label}}
      </label>

      <input
        type="text"
        placeholder="Select"
        value={{this.search}}
        {{on "input" this.updateSearch}}
        class="w-full px-3 py-2 text-sm border border-gray-300 rounded bg-white"
      />
    </div>
  </template>
}
