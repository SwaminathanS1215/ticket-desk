import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';
import clickOutside from 'ticket-desk/modifiers/click-outside.js';

export default class UserDropdown extends Component {
  @service router;
  @service session;
  @service auth;

  @tracked isOpen = false;

  get userName() {
    return this.session?.email || this.args.user || 'User';
  }

  @action toggleMenu(e) {
    e.stopPropagation();
    this.isOpen = !this.isOpen;
  }

  @action closeMenu() {
    this.isOpen = false;
  }

  @action async logout() {
    this.isOpen = false;
    await this.auth.logout();
    this.router.transitionTo('/');
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

      <button class="flex items-center gap-2 focus:outline-none" type="button">
        <img
          src="https://ui-avatars.com/api/?name={{this.userName}}&background=4F46E5&color=fff"
          class="w-8 h-8 rounded-full border border-indigo-300"
        />
        <span class="font-medium">{{this.userName}}</span>

        <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
          <path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7" />
        </svg>
      </button>

      {{#if this.isOpen}}
        <div
          class="absolute right-0 mt-2 w-52 bg-white rounded-md shadow-lg py-1 border border-gray-200 z-50"
          {{clickOutside this.toggleMenu condition=this.isOpen}}
        >

          <button
            class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors duration-150"
            type="button"
            {{on "click" this.closeMenu}}
          >
            Profile
          </button>

          <button
            class="block w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-50 transition-colors duration-150"
            type="button"
            {{on "click" this.closeMenu}}
          >
            Settings
          </button>

          <hr class="my-1 border-gray-200" />

          <button
            class="block w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-50 transition-colors duration-150"
            type="button"
            {{on "click" this.logout}}
          >
            Logout
          </button>

        </div>
      {{/if}}
    </div>
  </template>
}
