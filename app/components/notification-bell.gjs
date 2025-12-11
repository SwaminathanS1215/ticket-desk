import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import clickOutside from 'ticket-desk/modifiers/click-outside.js';
import { service } from '@ember/service';
import eq from 'ticket-desk/helpers/is-equal';
import gt from 'ticket-desk/helpers/is-equal';
import { fn } from '@ember/helper';
import formatDateTime from 'ticket-desk/utils/format-date-time';

export default class NotificationBell extends Component {
  @tracked isOpen = false;
  @service notificationService;

  get notifications() {
    return this.notificationService.items ?? [];
  }

  @action toggleMenu(e) {
    e.stopPropagation();
    this.isOpen = !this.isOpen;
  }

  @action closeMenu() {
    this.isOpen = false;
  }

  @action
  handleClickOutside() {
    this.isOpen = false;
  }

  @action
  async onMarkAllRead() {
    if (this.notificationService.markAllAsRead) {
      await this.notificationService.markAllAsRead();
    }
  }

  @action
  async onNotificationClick(note, e) {
    e?.stopPropagation?.();
    if (!note.read && this.notificationService.markAsRead) {
      await this.notificationService.markAsRead(note?.id);
    }
  }

  
formatTime(dateString) {
  return formatDateTime(dateString);
}


  <template>
    <div
      class="relative"
      {{on "click" this.toggleMenu}}
      {{clickOutside this.handleClickOutside condition=this.isOpen}}
    >

      <button class="relative p-2 rounded-full hover:bg-indigo-600/30 transition" type="button">
        <svg
          class="w-6 h-6 text-gray-1000"
          fill="none"
          stroke="currentColor"
          stroke-width="2"
          viewBox="0 0 24 24"
        >
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            d="M15 17h5l-1.405-1.405C17.214 14.214 17 13.11 17 12V9c0-2.21-1.79-4-4-4S9 6.79 9 9v3c0 1.11-.214 2.214-.595 3.595L7 17h5m3 0v1a2 2 0 11-4 0v-1m4 0H9"
          />
        </svg>
        {{#if (eq this.notificationService.hasUnread true)}}
          <span class="absolute top-1 right-1 w-2 h-2 rounded-full bg-red-500"></span>
        {{/if}}
      </button>

      {{#if this.isOpen}}
        <div
          class="absolute right-0 mt-2 w-[420px] bg-white rounded-lg shadow-2xl border border-gray-200 z-50"
          {{clickOutside this.toggleMenu condition=this.isOpen}}
        >
          <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200">
            <h2 class="text-xl font-semibold text-gray-900">Notifications</h2>
            <div class="flex items-center gap-4">
              <button
                type="button"
                class="text-sm font-medium text-blue-600 hover:text-blue-700 cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                {{on "click" this.onMarkAllRead}}
                disabled={{eq this.notificationService.hasUnread false}}
              >
                Mark all as read
              </button>
              {{! <button type="button" class="text-sm font-medium text-blue-600 hover:text-blue-700">
                Settings
              </button> }}
            </div>
          </div>

          <ul class="max-h-96 overflow-y-auto divide-y divide-gray-200">
            {{#if this.notifications.length}}
              {{#each this.notifications as |note|}}
                <li
                  class="px-6 py-4 hover:bg-gray-50 cursor-pointer transition-colors"
                  {{on "click" (fn this.onNotificationClick note)}}
                >
                  <div class="flex items-start gap-3">
                    <div class="flex-shrink-0 mt-1">
                      <div
                        class="w-10 h-10 bg-gray-200 rounded-full flex items-center justify-center"
                      >
                        <svg class="w-5 h-5 text-gray-600" fill="currentColor" viewBox="0 0 20 20">
                          <path
                            fill-rule="evenodd"
                            d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z"
                            clip-rule="evenodd"
                          />
                        </svg>
                      </div>
                    </div>
                    <div class="flex-1 min-w-0">
                      <p
                        class="{{if
                            note.read
                            'text-sm text-gray-700'
                            'text-sm text-gray-900 font-medium'
                          }}"
                      >
                        {{note.message}}
                      </p>

                      <p class="text-xs text-blue-600 mt-1 font-medium">
                        {{this.formatTime note.created_at}}
                      </p>
                    </div>
                  </div>
                </li>
              {{/each}}
            {{else}}
              <div class="px-6 py-4">
                <p class="text-sm text-gray-600">No new notifications</p>
              </div>
            {{/if}}
          </ul>
        </div>
      {{/if}}

    </div>
  </template>
}
