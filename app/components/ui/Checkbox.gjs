import Component from '@glimmer/component';

export default class Checkbox extends Component {
  <template>
    <label class="flex items-center space-x-2 cursor-pointer">
      <input type="checkbox" class="h-4 w-4 border-gray-300 rounded" />
    </label>
  </template>
}
