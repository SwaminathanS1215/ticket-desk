import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';

export default class NotificationBell extends Component {
  @tracked isOpen = false;

  get notifications() {
    return this.args.items ?? [
      { id: 1, message: 'New ticket assigned', time: '2m ago' },
      { id: 2, message: 'Server restart scheduled', time: '1h ago' },
      { id: 3, message: 'New comment on ticket', time: '2h ago' },
    ];
  }

  @action toggleMenu(e) {
    e.stopPropagation();
    this.isOpen = !this.isOpen;
  }

  @action closeMenu() {
    this.isOpen = false;
  }

  <template>
    <div class="relative" {{on "click" this.toggleMenu}}>

      <button class="relative p-2 rounded-full hover:bg-indigo-600/30 transition" type="button">
        <svg
          class="w-6 h-6 text-white"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path stroke-linecap="round" stroke-linejoin="round"
            d="M15 17h5l-1.405-1.405C17.214 14.214 17 13.11 17 12V9c0-2.21-1.79-4-4-4S9 6.79 9 9v3c0 1.11-.214 2.214-.595 3.595L7 17h5m3 0v1a2 2 0 11-4 0v-1m4 0H9"
          />
        </svg>

        <span
          class="absolute top-1 right-1 w-2 h-2 rounded-full bg-red-500"
        ></span>
      </button>

      {{#if this.isOpen}}
        <div
          class="absolute right-0 mt-2 w-72 bg-white text-gray-900 rounded shadow-xl border z-50"
        >
          <div class="px-4 py-3 bg-gray-100 border-b font-semibold">
            Notifications
          </div>

          <ul class="max-h-64 overflow-y-auto divide-y">
            {{#each this.notifications as |note|}}
              <li class="px-4 py-3 hover:bg-gray-50 cursor-pointer">
                <p class="text-sm font-medium">{{note.message}}</p>
                <p class="text-xs text-gray-500">{{note.time}}</p>
              </li>
            {{/each}}
          </ul>

          <button
            class="w-full text-center px-4 py-2 text-sm text-indigo-600 hover:bg-gray-100 border-t" type="button" {{on "click" this.closeMenu}}
          >
            View all
          </button>
        </div>
      {{/if}}

    </div>
  </template>
}
