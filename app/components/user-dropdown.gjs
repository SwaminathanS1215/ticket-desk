import Component from '@glimmer/component';
import { tracked } from '@glimmer/tracking';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import { service } from '@ember/service';

export default class UserDropdown extends Component {
  @service router;
  @service session;
  @service auth;

  @tracked isOpen = false;

  get userName() {
    return this.session.user?.email || this.args.user || 'User';
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
    this.router.transitionTo('index');
  }

  <template>
    <div class="relative" {{on "click" this.toggleMenu}}>

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
          class="absolute right-0 mt-2 w-48 bg-white text-gray-800 rounded shadow-lg py-2 border z-50"
        >

          <button
            class="block w-full text-left px-4 py-2 hover:bg-gray-100"
            type="button"
            {{on "click" this.closeMenu}}
          >
            Profile
          </button>

          <button
            class="block w-full text-left px-4 py-2 hover:bg-gray-100"
            type="button"
            {{on "click" this.closeMenu}}
          >
            Settings
          </button>

          <hr class="my-1" />

          <button
            class="block w-full text-left px-4 py-2 hover:bg-gray-100 text-red-600"
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
