import Component from '@glimmer/component';
import { on } from '@ember/modifier';

export default class Checkbox extends Component {
  <template>
    <input
      type="checkbox"
      class="h-4 w-4 border-gray-300 rounded cursor-pointer"
      checked={{@checked}}
      {{on "change" @onChange}}
      ...attributes
    />
  </template>
}
