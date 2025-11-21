import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { CreateIcon, TicketLargeIcon } from '../utils/icons';

export default class CreateMenu extends Component {
  @service createMenu;
  @service router;

  CreateIcon = CreateIcon;
  TicketLargeIcon = TicketLargeIcon;

  @action
  toggleMenu() {
    this.createMenu.toggle();
  }

  @action
  openCreateTicket() {
    this.createMenu.close();
    this.router.transitionTo('app.create-ticket');
  }

  <template>
    <div class="relative">
      <button
        type="button"
        class="w-10 h-10 flex items-center justify-center rounded-full bg-blue-600 hover:bg-blue-700 shadow text-white cursor-pointer transition"
        {{on "click" this.toggleMenu}}
      >
        {{this.CreateIcon}}
      </button>

      {{#if this.createMenu.open}}
        <div
          class="absolute right-0 mt-3 w-72 bg-white shadow-xl rounded-lg border border-gray-200 z-50"
        >
          <div
            class="flex items-center gap-4 px-4 py-3 hover:bg-gray-50 cursor-pointer"
            {{on "click" this.openCreateTicket}}
          >
            {{this.TicketLargeIcon}}
            <div>
              <p class="font-medium text-gray-800">Create Ticket</p>
              <p class="text-sm text-gray-500">Report an issue</p>
            </div>
          </div>
        </div>
      {{/if}}
    </div>
  </template>
}
