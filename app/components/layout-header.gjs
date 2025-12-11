import Component from '@glimmer/component';
import { service } from '@ember/service';
import { action } from '@ember/object';
import { on } from '@ember/modifier';
import UserDropdown from './user-dropdown.gjs';
import NotificationBell from './notification-bell.gjs';
import { MenuIcon } from '../utils/icons.js';
import CreateMenu from './create-menu.gjs';
import { tracked } from '@glimmer/tracking';

export default class LayoutHeader extends Component {
  @service session;
  @service sidebar;
  @service router;

  MenuIcon = MenuIcon;

  @tracked currentRouteName = null;

  constructor() {
    super(...arguments);
    this.router.on('routeDidChange', (transition) => {
      this.currentRouteName = transition.to.name;
    });
    this.currentRouteName = this.router.currentRouteName;
  }

  get title() {
    switch (this.currentRouteName) {
      case 'app.dashboard':
        return 'Dashboard';

      case 'app.ticket':
        return 'All Tickets';

      case 'app.create-ticket':
        return 'Create Ticket';

      case 'app.ticket-details':
        return 'Ticket Details';

      case 'app.update-ticket':
        return 'Update Ticket';

      default:
        return 'Ticket Desk';
    }
  }

  <template>
    <header
      class="fixed top-0 left-0 right-0 h-16 bg-white text-gray-1000 border-b border-gray-1001 flex items-center justify-between px-6 shadow z-40 pl-3 transition-all duration-300 ease-in-out"
      style={{this.sidebar.headerStyle}}
    >
      <div class="flex items-center gap-4">
        <h1 class="text-xl font-bold">{{this.title}}</h1>
      </div>
      <div class="flex items-center gap-4">
        <CreateMenu data-create-menu />
        <NotificationBell />
        {{#if this.session.isAuthenticated}}
          <UserDropdown @user={{this.session.user}} />
        {{/if}}
      </div>
    </header>
  </template>
}
