import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import UserDropdown from './user-dropdown.gjs';
import NotificationBell from './notification-bell.gjs';
import { MenuIcon } from '../utils/icons.js';


export default class LayoutHeader extends Component {
  @service session;
  @service sidebar;

  MenuIcon = MenuIcon;

  @action toggleSidebar() {
    this.sidebar.toggle();
  }

  <template>
    <header
      class="fixed top-0 left-0 right-0 h-16 bg-indigo-700 text-white 
             flex items-center justify-between px-6 shadow z-40 pl-3"
    >
      <div class="flex items-center gap-4">
        <button
          type="button"
          class="p-2 rounded hover:bg-indigo-600 transition"
          {{on "click" this.toggleSidebar}}
        >
          {{this.MenuIcon}}
        </button>
        <h1 class="text-xl font-bold">Ticket Desk</h1>
      </div>
      <div class="flex items-center gap-6">
        <NotificationBell />
        {{#if this.session.isAuthenticated}}
          <UserDropdown @user={{this.session.user}} />
        {{/if}}
      </div>
    </header>
  </template>
}
