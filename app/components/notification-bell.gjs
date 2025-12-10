import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import clickOutside from 'ticket-desk/modifiers/click-outside.js';
import { service } from '@ember/service';
import eq from 'ticket-desk/helpers/is-equal';
import gt from 'ticket-desk/helpers/is-equal';

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
        {{!-- {{}} --}}
        <span class="absolute top-1 right-1 w-2 h-2 rounded-full bg-red-500"></span>
      </button>

      {{#if this.isOpen}}
        <div
          class="absolute right-0 mt-2 w-[420px] bg-white rounded-lg shadow-2xl border border-gray-200 z-50"
          {{clickOutside this.toggleMenu condition=this.isOpen}}
        >
          <!-- Header -->
          <div class="flex items-center justify-between px-6 py-4 border-b border-gray-200">
            <h2 class="text-xl font-semibold text-gray-900">Notifications</h2>
            <div class="flex items-center gap-4">
              <button type="button" class="text-sm font-medium text-blue-600 hover:text-blue-700">
                Mark all as read
              </button>
              <button type="button" class="text-sm font-medium text-blue-600 hover:text-blue-700">
                Settings
              </button>
            </div>
          </div>

          <!-- Mobile App Banner -->
          {{! <div class="px-6 py-4 bg-gray-50 border-b border-gray-200">
            <div class="flex items-start gap-3">
              <div class="flex-shrink-0">
                <div class="w-10 h-10 bg-blue-500 rounded-lg flex items-center justify-center">
                  <svg class="w-6 h-6 text-white" fill="currentColor" viewBox="0 0 20 20">
                    <path
                      d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z"
                    />
                  </svg>
                </div>
              </div>
              <div class="flex-1">
                <h3 class="text-base font-semibold text-gray-900 mb-1">
                  Install Freshservice Mobile App
                </h3>
                <p class="text-sm text-gray-600 mb-2">
                  Stay on top of your notifications on the go!
                </p>
                <button
                  type="button"
                  class="text-sm font-medium text-blue-600 hover:text-blue-700 inline-flex items-center gap-1"
                >
                  Install now
                  <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M9 5l7 7-7 7"
                    />
                  </svg>
                </button>
              </div>
            </div>
          </div> }}

          <!-- Filter Tabs -->
          {{! <div class="flex gap-2 px-6 py-3 border-b border-gray-200 bg-white">
            <button
              type="button"
              class="px-4 py-1.5 text-sm font-medium text-white bg-blue-600 rounded-full hover:bg-blue-700"
            >
              All
            </button>
            <button
              type="button"
              class="px-4 py-1.5 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded-full"
            >
              Approvals
            </button>
            <button
              type="button"
              class="px-4 py-1.5 text-sm font-medium text-gray-700 hover:bg-gray-100 rounded-full"
            >
              Discussions
            </button>
          </div> }}

          <!-- Notifications List -->
          <ul class="max-h-96 overflow-y-auto divide-y divide-gray-200">
            {{#each this.notifications as |note|}}
              <li class="px-6 py-4 hover:bg-gray-50 cursor-pointer transition-colors">
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
                    <div class="flex items-start gap-2 mb-1">
                      <svg
                        class="w-4 h-4 text-gray-500 mt-0.5 flex-shrink-0"
                        fill="currentColor"
                        viewBox="0 0 20 20"
                      >
                        <path
                          d="M2 5a2 2 0 012-2h7a2 2 0 012 2v4a2 2 0 01-2 2H9l-3 3v-3H4a2 2 0 01-2-2V5z"
                        />
                      </svg>
                      <span class="text-sm font-medium text-gray-900">Ticket Assigned</span>
                    </div>
                    <p class="text-sm text-gray-700">
                      {{note.message}}
                    </p>
                    <p class="text-xs text-blue-600 mt-1 font-medium">
                      {{note.time}}
                    </p>
                  </div>
                </div>
              </li>
            {{/each}}
          </ul>

          {{#if (eq this.notifications.length 0)}}
            <div class="px-6 py-4">
              <p class="text-sm text-gray-600">No new notifications</p>
            </div>
          {{/if}}
          {{#if (gt this.notifications.length 5)}}
            <button
              class="w-full text-center px-6 py-3 text-sm font-medium text-blue-600 hover:bg-gray-50 border-t border-gray-200 transition-colors"
              type="button"
              {{on "click" this.closeMenu}}
            >
              View all
            </button>
          {{/if}}
        </div>
      {{/if}}

    </div>
  </template>
}
