import Component from '@glimmer/component';
import { service } from '@ember/service';

export default class AppToastComponent extends Component {
  @service toast;

  getClass(type) {
    switch (type) {
      case 'success':
        return 'bg-green-600';
      case 'error':
        return 'bg-red-600';
      case 'info':
        return 'bg-blue-600';
      case 'warning':
        return 'bg-yellow-600 text-black';
      default:
        return 'bg-gray-800';
    }
  }

  <template>
    <div class="fixed top-4 right-4 space-y-3 z-50">
      {{#each this.toast.messages as |msg|}}
        <div
          class="text-white px-4 py-2 rounded shadow-lg transition-all"
        >
          {{msg.text}}
        </div>
      {{/each}}
    </div>
  </template>
}
